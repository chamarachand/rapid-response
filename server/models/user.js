const Joi = require("joi");
const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  firstName: { type: String, minlength: 2, maxlength: 50, required: true },
  lastName: { type: String, minlength: 2, maxlength: 50, required: true },
  nicNo: { type: String, minlength: 9, maxlength: 12, required: true },
  gender: { type: String, enum: ["Male", "Female", "Other"], required: true },
  birthDay: { type: Date, required: true },
  phoneNumber: { type: String, required: true },
  email: {
    type: String,
    minlength: 5,
    maxlength: 255,
    unique: true,
    required: true,
  },
  username: { type: String, unique: true, required: true },
  password: { type: String, minlength: 8, maxlength: 1024, required: true },
});

const User = mongoose.model("User", userSchema);
