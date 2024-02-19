const express = require("express");
const router = express.Router();
const Joi = require("joi");

router.post("/", async (req, res) => {
  const { error } = validate(req.body);

  if (error) return res.status(400).send(error.details[0].message);

  const givenNicNo = req.body.nicNo;
  const givenGender = req.body.gender;
  const givenDob = new Date(req.body.birthDay + "Z");

  const { gender, dob } = getGenderAndDob(givenNicNo);

  console.log(dob);
  console.log(givenDob);

  if (gender === givenGender && datesMatch(dob, givenDob))
    return res.status(200).send("Valid");

  return res.status(403).send("Invalid");
});

function getGenderAndDob(nicNo) {
  const isOldNic = nicNo.length == 10;
  // const detailsCode = parseInt(
  //   isOldNic ? nicNo.substring(2, 5) : nicNo.substring(4, 7)
  // );

  const detailsCode = isOldNic
    ? parseInt(nicNo.substring(2, 5)) - 1
    : parseInt(nicNo.substring(4, 7));

  const birthYear = parseInt(
    isOldNic ? nicNo.substring(0, 2) : nicNo.substring(0, 4)
  );

  const gender = detailsCode < 500 ? "Male" : "Female";
  let dob = new Date(Date.UTC(birthYear, 0, 1)); // Set timezone to UTC
  dob.setUTCDate(detailsCode < 500 ? detailsCode : detailsCode - 500);
  // let dob = new Date(birthYear, 0);
  // console.log(detailsCode);
  // dob.setDate(detailsCode < 500 ? detailsCode : detailsCode - 500);

  console.log(dob);
  // dob = new Date(Date.UTC(dob.getFullYear(), dob.getMonth(), dob.getDate())); // Convert to UTC Date

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

module.exports = router;
