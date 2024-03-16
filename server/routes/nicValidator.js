const express = require("express");
const router = express.Router();
const Joi = require("joi");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");

router.post("/", async (req, res) => {
  const { error } = validate(req.body);

  if (error) return res.status(400).send(error.details[0].message);

  const givenNicNo = req.body.nicNo;
  const givenGender = req.body.gender;
  const givenDob = new Date(req.body.birthDay + "Z");

  const { gender, dob } = getGenderAndDob(givenNicNo);

  if (gender === givenGender && datesMatch(dob, givenDob))
    return res.status(200).send("Valid");

  return res.status(403).send("Invalid");
});

router.post("/is-unique", async (req, res) => {
  const { error } = Joi.object({
    nicNo: Joi.string()
      .min(9)
      .max(12)
      .regex(/^(?:\d{9}[Vv]|\d{12})$/)
      .required(),
  }).validate(req.body);

  if (error) return res.status(400).send(error.details[0].message);

  const { userType } = req.query;

  if (userType !== "civilian" && userType !== "first-responder")
    return res.status(400).send("Bad Request");

  const { nicNo } = req.body;

  const user =
    userType === "civilian"
      ? await Civilian.findOne({ nicNo: nicNo })
      : await FirstResponder.findOne({ nicNo: nicNo });

  if (user)
    return res.status(200).send("User with the given id already exists");
  return res.status(404).send("User with the given id not found");
});

function getGenderAndDob(nicNo) {
  const isOldNic = nicNo.length == 10;

  let detailsCode = isOldNic
    ? parseInt(nicNo.substring(2, 5))
    : parseInt(nicNo.substring(4, 7));

  const birthYear = parseInt(
    isOldNic ? nicNo.substring(0, 2) : nicNo.substring(0, 4)
  );

  // As the day of the year is calculated, considering every year as a leap year (in SL)
  if (!isLeapYear(birthYear) && detailsCode > 59) detailsCode--;

  const gender = detailsCode < 500 ? "Male" : "Female";
  let dob = new Date(Date.UTC(birthYear, 0, 1)); // Set timezone to UTC
  dob.setUTCDate(detailsCode < 500 ? detailsCode : detailsCode - 500);

  return { gender, dob };
}

function validate(req) {
  const genderValues = ["Male", "Female", "Other"];

  const schema = Joi.object({
    nicNo: Joi.string()
      .min(9)
      .max(12)
      .regex(/^(?:\d{9}[Vv]|\d{12})$/)
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

function isLeapYear(year) {
  return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

module.exports = router;
