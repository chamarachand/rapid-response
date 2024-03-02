const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

router.post("/", async (req, res) => {
  try {
    admin.messaging().send({
      token:
        "cHbcFdBQTGCquDG7KizdYJ:APA91bGT3I5QQKA3VdFZzhxds2SXeeSYrl0fqo9i_np22sishsZoDeunSakd4szE-DVuSHxMSa8MGlCjPfsCU_lBSVEitOkTmlukfwEYqG4QyI7JSTEG5wE6SVQyd6pOmMYd_ADV1mbo",
      notification: {
        title: "This is notification",
        body: "Test notification",
      },
    });
    console.log("Notification send successfully");
    res.send("Send Success");
  } catch (error) {
    console.error("Error: " + error);
  }
});

module.exports = router;
