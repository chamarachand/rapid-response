const mongoose = require("mongoose");
const { User } = require("./user");

const responderValues = ["Police", "Paramedic", "Fire"]; // Add more

const firstResponderSchema = new mongoose.Schema({
  responderType: { type: String, enum: responderValues, required: true },
  departmentName: { type: String, minlength: 5, maxlength: 255, required },
  departmentId: { type: String, maxlength: 32, required: true },
});

const FirstResponder = User.discriminator(
  "FirstResponder",
  firstResponderSchema
);

module.exports = FirstResponder;
