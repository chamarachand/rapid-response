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

// Check if the inteded user is already an emergency contact
router.get(
  "/search/emcontact/:currentUserId/:intendedUserId",
  async (req, res) => {
    const { currentUserId, intendedUserId } = req.params;

    if (!currentUserId || !intendedUserId)
      return res.status(400).send("Missing parameter/s");

    const currentUser = await Civilian.findById(currentUserId).select(
      "emergencyContacts"
    );

    const isEmergencyContact =
      currentUser.emergencyContacts.includes(intendedUserId);

    return isEmergencyContact
      ? res.status(200).send("Intended user is already an emergency contact")
      : res.status(404).send("Intended user is not an emergency contact");
  }
);

router.get(
  "/search/request/:currentUserId/:intendedUserId",
  async (req, res) => {
    const { currentUserId, intendedUserId } = req.params;

    if (!currentUserId || !intendedUserId)
      return res.status(400).send("Missing parameter/s");

    const intendedUser = await Civilian.findById(intendedUserId).select(
      "notifications"
    );

    for (let objectId of intendedUser.notifications) {
      const notification = await Notification.findById(objectId);

      if (
        notification &&
        notification.from == currentUserId && // replace == with === when connected with front end
        notification.type === "emergency-contact-request" &&
        !notification.responded
      )
        return res.status(200).send("Request for intended user already sent");
    }

    return res.status(404).send("Request for intended user not sent");
  }
);

router.post("/send", async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { from, to, title, body } = req.body;
  let notification;

  // Save to db - notifications collection
  try {
    notification = new Notification({
      from: from,
      to: to,
      type: "emergency-contact-request",
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
  const { fcmToken } = await Civilian.findById(to).select("fcmToken"); // Add if not token logic
  if (!fcmToken) return res.status(404).send("Reciever FCM token not found");

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
