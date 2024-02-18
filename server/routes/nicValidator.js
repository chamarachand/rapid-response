const express = require("express");
const router = express.Router();
const Joi = require("joi");

router.post("/", async (req, res) => {
  const { error } = validate(req.body);

  if (error) return res.status(400).send(error.details[0].message);

  const nicNo = req.body.nicNo;

  const details = parseInt(nicNo.substring(2, 5));
  const gender = details < 500 ? "Male" : "Female";

  const birthYear = parseInt("19" + nicNo.substring(0, 2));
  const dob = new Date(birthYear, 0);
  dob.setDate(details);

  const givenGender = req.body.gender;
  const givenDob = new Date(req.body.birthDay + "Z");

  if (gender === givenGender && datesMatch(dob, givenDob))
    return res.status(200).send("Valid");

  return res.status(403).send("Invalid");
});

function validate(req) {
  const genderValues = ["Male", "Female", "Other"];

  const schema = Joi.object({
    nicNo: Joi.string()
      .min(9)
      .max(12)
      .regex(/^(?:\d{9}[Vv]|\d{12})$/)
      .trim()
      .required(),
    gender: Joi.string().valid(...genderValues),
    birthDay: Joi.string().required(),
  });

  return schema.validate(req);
}

function datesMatch(date1, date2) {
  return (
    date1.getUTCFullYear() === date2.getUTCFullYear() &&
    date1.getUTCMonth() === date2.getUTCMonth() &&
    date1.getUTCDate() === date2.getUTCDate()
  );
}

module.exports = router;
