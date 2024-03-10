const mongoose = require("mongoose");
const Joi = require("joi");
const { userSchema, userValidationSchema } = require("../common/sharedSchema");

const responderValues = ["Police", "Paramedic", "Fire"]; // Add more

const firstResponderSchema = new mongoose.Schema({
  ...userSchema.obj,
  type: { type: String, enum: responderValues, required: true },
  workId: { type: String, maxlength: 32, required: true },
  workAddress: {
    type: String,
    minlength: 5,
    maxlength: 255,
    required: true,
  },
  supervisorAccounts: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
  superviseeAccounts: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
});

firstResponderSchema.methods.generateAuthToken = function () {
  return jwt.sign(
    { userType: "civilian", username: this.username },
    "jwtPrivateKey" // Change this to config.get("jwtPrvateKey")
  );
};

const FirstResponder = mongoose.model("FirstResponder", firstResponderSchema);

function validateFirstResponder(user) {
  const firstResponderValidationSchema = userValidationSchema.keys({
    type: Joi.string()
      .valid(...responderValues)
      .required(),
    workId: Joi.string().max(32).required(),
    workAddress: Joi.string().min(5).max(255).required(),
  });
  return firstResponderValidationSchema.validate(user);
}

module.exports = { FirstResponder, validate: validateFirstResponder };
