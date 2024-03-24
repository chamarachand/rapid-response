const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const authMiddleware = require("../middleware/authMiddleware");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");
const { Notification, validate } = require("../models/notification");
const { sendNotification } = require("../services/notificationService");
const { SOSReport } = require("../models/sosReport");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

// Get latest notifications
router.get("/latest/:count", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  const { count } = req.params;

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
  "/search/request/:intendedUserId",
  authMiddleware,
  async (req, res) => {
    const currentUserId = req.user.id;
    const { intendedUserId } = req.params;
    const { type } = req.query;

    if (!currentUserId || !intendedUserId || !type)
      return res.status(400).send("Bad Request");

    const [civilian, firstResponder] = await Promise.all([
      Civilian.findById(intendedUserId).select("notifications"),
      FirstResponder.findById(intendedUserId).select("notifications"),
    ]);

    const user = civilian || firstResponder;

    if (!user)
      return res.status(400).send("Intended user with given id not found");

    const notifications = await Notification.find({
      _id: { $in: user.notifications }, // Filter notifications by those in the intended user's notifications array
      from: currentUserId, // Filter notifications by the sender
      type: type,
      responded: false,
    });

    if (notifications.length >= 1)
      return res.status(200).send("Request for intended user already sent");

    return res.status(404).send("Request for intended user not sent");
  }
);

// Get pending add as requests for a user
router.get("/requests", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  const { type } = req.query;

  if (!userId || !type) return res.status(400).send("Bad request");

  try {
    const notifications = await Notification.find({
      to: userId, // Filter notifications by those in the intended user's notifications array
      type: type,
      responded: false,
    })
      .select("from")
      // .populate({
      //   path: "from",
      //   select: "_id firstName lastName",
      // })
      .sort({ timestamp: -1 });

    if (notifications.length === 0)
      return res.status(404).send("No pending supervisee requets");

    const formattedNotifications = [];
    for (const notification of notifications) {
      const civilian = await Civilian.findById(notification.from).select(
        "_id firstName lastName profilePic"
      );

      const firstResponder = await FirstResponder.findById(
        notification.from
      ).select("_id firstName lastName profilePic");
      const user = civilian || firstResponder;

      const formattedNotification = {
        _id: notification._id,
        from: {
          _id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          profilePic: user.profilePic,
        },
      };

      formattedNotifications.push(formattedNotification);
    }
    return res.status(200).send(formattedNotifications);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

// Change responded to true in a notification
router.patch("/responded/:notificationId", authMiddleware, async (req, res) => {
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
router.post("/send", authMiddleware, async (req, res) => {
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

  let user = civilian || firstResponder;

  if (!user)
    return res.status(404).send("Receiver with the given id not found");

  // Send notification

  // const { fcmToken } = await Civilian.findById(to).select("fcmToken");
  // if (!fcmToken) return res.status(404).send("Reciever FCM token not found");

  const [fcmTokenCivilian, fcmTokenFirstResponder] = await Promise.all([
    Civilian.findById(to).select("fcmToken"),
    FirstResponder.findById(to).select("fcmToken"),
  ]);
  const fcmToken =
    fcmTokenCivilian?.fcmToken || fcmTokenFirstResponder?.fcmToken;
  if (!fcmToken) return res.status(202).send("Reciever FCM token not found");

  const send = sendNotification(fcmToken, title, body);
  return send
    ? res.status(200).send("Notification send successfully")
    : res.status(202).send("Request created. Failed to send the notification");
  // try {
  //   admin.messaging().send({
  //     token: fcmToken,
  //     notification: {
  //       title: title,
  //       body: body,
  //     },
  //   });
  //   console.log("Notification send successfully");
  //   res.status(200).send("Send Success");
  // } catch (error) {
  //   console.error("Error: " + error);
  //   res.status(500).send("Internal Server Error");
  // }
});

// send sos. incident notifications for emergency contacts
router.post("/emergency-contacts/send", authMiddleware, async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { type, title, body } = req.body;

  const userId = req.user.id;
  if (!userId) return res.status(400).send("Bad request");

  let notification;

  const { emergencyContacts } = await Civilian.findById(userId).select(
    "emergencyContacts"
  );

  if (!emergencyContacts)
    return res
      .status(404)
      .send("Emergency contact field for the given user not found");
  if (emergencyContacts.length === 0)
    return res.status(204).send("No emergency contacts for the given user");

  allNotified = true;

  for (const contact of emergencyContacts) {
    // Save to db - notifications collection
    try {
      notification = new Notification({
        from: userId,
        to: contact,
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
    const emergencyContact = await Civilian.findByIdAndUpdate(
      contact,
      { $push: { notifications: notification._id } },
      { new: true }
    );

    if (!emergencyContact)
      return res.status(404).send("Receiver with the given id not found");

    // send notification
    const { fcmToken } = await Civilian.findById(contact).select("fcmToken");
    if (!fcmToken) return res.status(404).send("Reciever FCM token not found");

    const send = await sendNotification(fcmToken, title, body);
    if (!send) allNotified = false;
  }

  return allNotified
    ? res.status(200).send("Notification send to all emergency contacts")
    : res.status(417).send("Notification sending failed");
});

// send sos. incident notifications for emergency contacts
router.post(
  "/first-responder/send/:emergencyType/:emergencyId",
  authMiddleware,
  async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const { type, title, body } = req.body;

    const userId = req.user.id;
    const { emergencyType, emergencyId } = req.params;

    if (!userId || !emergencyType || !emergencyId)
      return res.status(400).send("Bad request");

    const isSOS = emergencyType === "sos-report";

    let notification;

    const firstResponders = await FirstResponder.find({
      availability: true,
    }).select("_id");

    if (!firstResponders)
      return res.status(404).send("No first responders available");
    if (firstResponders.length === 0)
      return res.status(204).send("No emergency contacts for the given user");

    let allNotified = true;

    for (const responder of firstResponders) {
      // Save to db - notifications collection
      try {
        notification = new Notification({
          from: userId,
          to: responder._id,
          type: type,
          title: title,
          body: body,
          timestamp: new Date().toLocaleString(),
          responded: false,
        });

        await notification.save();
      } catch (error) {
        console.log("Error: ");
        return res.status(500).send(error);
      }

      // Save to db - firstResponder notifications
      const updateQuery = {
        $push: {
          notifications: notification._id,
        },
      };

      if (isSOS) {
        updateQuery.$push.sosReports = emergencyId;
      } else {
        updateQuery.$push.incidentReports = emergencyId;
      }

      const firstResponder = await FirstResponder.findByIdAndUpdate(
        responder,
        updateQuery,
        { new: true }
      );

      if (!firstResponder)
        return res
          .status(404)
          .send("First Responder with the given id not found");

      // send notification
      const { fcmToken } = await FirstResponder.findById(responder).select(
        "fcmToken"
      );
      if (!fcmToken)
        return res.status(404).send("Reciever FCM token not found");

      const send = await sendNotification(fcmToken, title, body);
      if (!send) allNotified = false;
    }

    return allNotified
      ? res.status(200).send("Notification send to all emergency contacts")
      : res.status(417).send("Notification sending failed");
  }
);

module.exports = router;
