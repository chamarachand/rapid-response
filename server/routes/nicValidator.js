const express = require("express");
const router = express.Router();
const Joi = require("joi");

router.post("/", async (req, res) => {
  const { error } = validate(req.body);

  if (error) return res.status(400).send(error.details[0].message);

  const details = parseInt(req.body.nicNo.substring(2, 5));
  const gender = details < 500 ? "Male" : "Female";

  const date = new Date();
  const birthYear = parseInt("19" + req.body.nicNo.substring(0, 2));
  date.setFullYear(birthYear);
  date.setMonth(details);
  date.setDate(details);

  console.log(date);
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

module.exports = router;
