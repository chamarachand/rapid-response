const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const { Civilian } = require("../models/civilian");
const { Notification, validate } = require("../models/notification");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

router.post("/", async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { from, to, title, body } = req.body;

  // Save to db - notifications collection
  try {
    const notification = new Notification({
      from: from,
      to: to,
      title: title,
      body: body,
      timestamp: new Date().toLocaleString(),
    });

    await notification.save();
  } catch (error) {
    console.log("Error: ");
    res.status(500).send(error);
  }

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
