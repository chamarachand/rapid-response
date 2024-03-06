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
    const { error } = loginValidationSchema.validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const [civilian, firstResponder] = await Promise.all([
      Civilian.findOne({ username: req.body.username }),
      FirstResponder.findOne({ username: req.body.username }),
    ]);

    if (!civilian && !firstResponder)
      return res.status(401).send("Invalid username or password");

    const user = civilian || firstResponder;

    const correctPassword = await validatePassword(
      req.body.password,
      user.password
    );

    if (!correctPassword)
      return res.status(401).send("Invalid username or password");

    const token = user.generateAuthToken();
    //-sahan- added id token
    const id_token = user.generateIdToken();
    // res.send(token);
//-sahan- added id token
    res.send({ token: token, id_token: id_token });

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

async function validatePassword(plainTextPassword, hashedPassword) {
  return await bcrypt.compare(plainTextPassword, hashedPassword);
}

module.exports = router;
