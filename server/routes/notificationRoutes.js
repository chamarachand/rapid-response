const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");
const { Notification, validate } = require("../models/notification");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Get latest notifications
router.get("/latest/:userId/:count", async (req, res) => {
  const { userId, count } = req.params;

  if (!userId || !count || isNaN(parseInt(count)) || parseInt(count) <= 0)
    return res.status(400).send("Bad Request");

  try {
    const notifications = await Notification.find({
      to: userId,
    })
      .select("_id type from title body timestamp")
      .sort({ timestamp: -1 })
      .limit(parseInt(count));

    if (notifications.length < 1)
      return res.status(404).send("No notifications found for the user");

    return res.status(200).send(notifications);
  } catch (error) {
    console.log("Error: ", error);
    return res.status(500).send("Internal Server Error");
  }
});

// Check if a request has been already sent to the intended user
router.get(
  "/search/request/:currentUserId/:intendedUserId",
  async (req, res) => {
    const { currentUserId, intendedUserId } = req.params;
    const { type } = req.query;

    if (!currentUserId || !intendedUserId || !type)
      return res.status(400).send("Bad Request");

    const intendedUser = await Promise.any([
      Civilian.findById(intendedUserId).select("notifications"),
      FirstResponder.findById(intendedUserId).select("notifications"),
    ]);

    if (!intendedUser)
      return res.status(400).send("Intended user with given id not found");
    // We can refactor this
    const notifications = await Notification.find({
      _id: { $in: intendedUser.notifications }, // Filter notifications by those in the intended user's notifications array
      from: currentUserId, // Filter notifications by the sender
      type: type,
      responded: false,
    });

    if (notifications.length >= 1)
      return res.status(200).send("Request for intended user already sent");

    return res.status(404).send("Request for intended user not sent");
  }
);

// Get pending add as emergency contact requests for a user
router.get("/emergency-contact-requests/:userId", async (req, res) => {
  const { userId } = req.params;
  if (!userId) return res.status(400).send("Bad request");

  try {
    const notifications = await Notification.find({
      to: userId, // Filter notifications by those in the intended user's notifications array
      type: "emergency-contact-request",
      responded: false,
    })
      .select("from")
      .populate({
        path: "from",
        select: "_id firstName lastName",
      })
      .sort({ timestamp: -1 });

    if (notifications.length === 0)
      return res.status(404).send("No pending emergency contact requets");
    return res.status(200).send(notifications);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

// Change responded to true in a notification
router.patch("/responded/:notificationId", async (req, res) => {
  const { notificationId } = req.params;

  if (!notificationId) return res.status(400).send("Bad Request");
  try {
    const updatedNotification = await Notification.findByIdAndUpdate(
      notificationId,
      { responded: true },
      { new: true }
    );

    if (!updatedNotification)
      return res.status(404).send("Notification with the given id not found");

    return res.status(200).send("Notification updated successfully");
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal server error");
  }
});

// send request notifications
router.post("/send", async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { from, to, type, title, body } = req.body;
  let notification;

  // Save to db - notifications collection
  try {
    notification = new Notification({
      from: from,
      to: to,
      type: type,
      title: title,
      body: body,
      timestamp: new Date().toLocaleString(),
      responded: false,
    });

    await notification.save();
  } catch (error) {
    console.log("Error: ");
    res.status(500).send(error);
  }

  // Save to db - user notifications
  const [civilian, firstResponder] = await Promise.all([
    Civilian.findByIdAndUpdate(
      to,
      { $push: { notifications: notification._id } },
      { new: true }
    ),
    FirstResponder.findByIdAndUpdate(
      to,
      { $push: { notifications: notification._id } },
      { new: true }
    ),
  ]);

  const user = civilian || firstResponder;

  if (!user)
    return res.status(404).send("Receiver with the given id not found");

  // Send notification
  const { fcmToken } = await Promise.any([
    Civilian.findById(to).select("fcmToken"),
    FirstResponder.findById(to).select("fcmToken"),
  ]);
  if (!fcmToken)
    return res
      .status(202)
      .send("Notification accepted; Reciever FCM token not found");

  try {
    admin.messaging().send({
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
    });
    console.log("Notification send successfully");
    res.send("Send Success");
  } catch (error) {
    console.error("Error: " + error);
    res.status(500).send("Internal Server Error");
  }
});

module.exports = router;
