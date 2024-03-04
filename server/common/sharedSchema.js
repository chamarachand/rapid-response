const mongoose = require("mongoose");
const Joi = require("joi");

const genderValues = ["Male", "Female"];

// Schema for validating the user before storing in MongoDB
const userSchema = new mongoose.Schema({
  firstName: { type: String, minlength: 2, maxlength: 50, required: true },
  lastName: { type: String, minlength: 2, maxlength: 50, required: true },
  nicNo: { type: String, minlength: 9, maxlength: 12, required: true },
  gender: { type: String, enum: genderValues, required: true },
  birthDay: { type: Date, required: true },
  phoneNumber: { type: String, required: true },
  email: {
    type: String,
    minlength: 5,
    maxlength: 255,
    unique: true,
    required: true,
  },
  username: {
    type: String,
    minlength: 4,
    maxlength: 16,
    unique: true,
    required: true,
  },
  password: { type: String, minlength: 8, maxlength: 255, required: true },
  fcmToken: { type: String, maxlength: 255, default: null },
});

// Convert Date into UTC format before saving in the database
userSchema.pre("save", function (next) {
  if (this.birthDay) {
    this.birthDay = new Date(
      Date.UTC(
        this.birthDay.getFullYear(),
        this.birthDay.getMonth(),
        this.birthDay.getDate()
      )
    );
  }
  next();
});

// Schema for validating the incoming http request with user details in the body
const userValidationSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
  nicNo: Joi.string()
    .min(9)
    .max(12)
    .regex(/^(?:\d{9}[Vv]|\d{12})$/)
    .required(),
  gender: Joi.string().valid(...genderValues),
  birthDay: Joi.string().required(), // Add date validation
  phoneNumber: Joi.string().required(), // Add phone number validation
  email: Joi.string().email().min(5).max(255).required(),
  username: Joi.string().min(4).max(16).required(),
  password: Joi.string().min(8).max(255).required(),
});

const loginValidationSchema = Joi.object({
  username: Joi.string().min(4).max(16).required(),
  password: Joi.string().min(8).max(255).required(),
});

module.exports = { userSchema, userValidationSchema, loginValidationSchema };
