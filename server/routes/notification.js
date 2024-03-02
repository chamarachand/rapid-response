const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const { not } = require("joi");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

router.post("/", async (req, res) => {
  const notification = req.body; // Later validate this

  try {
    admin.messaging().send({
      token: notification.fcmToken,
      notification: {
        title: notification.title,
        body: notification.body,
      },
    });
    console.log("Notification send successfully");
    res.send("Send Success");
  } catch (error) {
    console.error("Error: " + error);
  }
});

module.exports = router;
