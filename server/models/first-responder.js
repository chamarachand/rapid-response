const mongoose = require("mongoose");
const Joi = require("joi");
const { userSchema, userValidationSchema } = require("../common/sharedSchema");

const responderValues = ["Police", "Paramedic", "Fire"]; // Add more

const firstResponderSchema = new mongoose.Schema({
  ...userSchema.obj,
  responderType: { type: String, enum: responderValues, required: true },
  departmentName: {
    type: String,
    minlength: 5,
    maxlength: 255,
    required: true,
  },
  departmentId: { type: String, maxlength: 32, required: true },
});

const FirstResponder = mongoose.model("FirstResponder", firstResponderSchema);

function validateFirstResponder(user) {
  const firstResponderValidationSchema = userValidationSchema.keys({
    responderType: Joi.string()
      .valid(...responderValues)
      .required(),
    departmentName: Joi.string().min(5).max(255).required(),
    departmentId: Joi.string().max(32).required(),
  });
  return firstResponderValidationSchema.validate(user);
}

module.exports = { FirstResponder, validate: validateFirstResponder };
