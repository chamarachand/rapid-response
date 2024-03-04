const express = require("express");
const router = express.Router();
const Joi = require("joi");
const bcrypt = require("bcrypt");
const config = require("config");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");
const { loginValidationSchema } = require("../common/sharedSchema");

router.post("/", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const [civilian, firstResponder] = await Promise.all([
      Civilian.findOne({ username: req.body.username }),
      FirstResponder.findOne({ username: req.body.username }),
    ]);

    if (!civilian && !firstResponder)
      return res.status(401).send("Invalid username or password");

    const user = civilian || firstResponder;
    // const userType = civilian ? "civilian" : "first responder";

    if (!correctPassword(req.body.password, user.password))
      return res.status(401).send("Invalid username or password");

    const token = user.generateAuthToken();
    // res.send(token);

    res.send({ token: token });
  } catch (error) {
    res.status(500).send("Internal server error");
  }
});

router.patch("/update-fcm-token", async (req, res) => {
  // set authMiddleware
  const { username, fcmToken } = req.body;

  // Later Create a schema toValidate userId and fcmToken
  if (!username || !fcmToken) {
    return res.status(400).json({ error: "Invalid data" });
  }

  const [civilian, firstResponder] = await Promise.all([
    Civilian.findOneAndUpdate(
      { username: username },
      { $set: { fcmToken: fcmToken } },
      { new: true }
    ),
    FirstResponder.findOneAndUpdate(
      { username: username },
      { $set: { fcmToken: fcmToken } },
      { new: true }
    ),
  ]);

  if (!civilian && !firstResponder)
    return res.status(401).send("User with the given id not found");

  const user = civilian || firstResponder;

  res.status(200).send("FCM Token updated successfully");
});

// Can add this schema in the sharedSchema
function validate(req) {
  return loginValidationSchema.validate(req);
}

async function correctPassword(plainTextPassword, hashedPassword) {
  return await bcrypt.compare(plainTextPassword, hashedPassword);
}

module.exports = router;
