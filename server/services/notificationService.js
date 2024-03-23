var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

async function sendNotification(fcmToken, title, body) {
  try {
    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
    });
    console.log("Notification send successfully");
    return true;
  } catch (error) {
    console.error("Error: " + error);
    return false;
  }
}

module.exports = { sendNotification };
