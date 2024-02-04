const mongoose = require("mongoose");
const { User, userValidationSchema } = require("./user");

const civilianSchema = new mongoose.Schema();

const Civilian = User.discriminator("Civilian", civilianSchema);

function validateCivilian(user) {
  return userValidationSchema.validate(user);
}

module.exports = { Civilian, validate: validateCivilian };
