const mongoose = require("mongoose");
const { userSchema, userValidationSchema } = require("../common/sharedSchema");

const civilianSchema = new mongoose.Schema(userSchema);

const Civilian = mongoose.model("Civilian", civilianSchema);

function validateCivilian(user) {
  return userValidationSchema.validate(user);
}

module.exports = { Civilian, validate: validateCivilian };
