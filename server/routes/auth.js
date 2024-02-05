const express = require("express");
const router = express.Router();
const Joi = require("joi");
const bcrypt = require("bcrypt");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");

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
    const userType = civilian ? "civilian" : "first responder";

    if (!correctPassword(req.body.password, user.password))
      return res.status(401).send("Invalid username or password");

    return res
      .status(200)
      .send({ message: "Login successful", userType: userType });
  } catch (error) {
    res.status(500).send("Internal server error");
  }
});

// Can add this schema in the sharedSchema
function validate(req) {
  const loginValidationSchema = Joi.object({
    username: Joi.string().min(4).max(16).required(),
    password: Joi.string().min(8).max(255).required(),
  });

  return loginValidationSchema.validate(req);
}

async function correctPassword(plainTextPassword, hashedPassword) {
  return await bcrypt.compare(plainTextPassword, hashedPassword);
}

module.exports = router;
