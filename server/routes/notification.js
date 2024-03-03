const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const { Civilian } = require("../models/civilian");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

router.post("/", async (req, res) => {
  const { to, title, body } = req.body; // Later validate this

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
  }
});

module.exports = router;
