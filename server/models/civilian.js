const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const { userSchema, userValidationSchema } = require("../common/sharedSchema");

const civilianSchema = new mongoose.Schema({
  ...userSchema.obj,
  emergencyContacts: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Civilian",
      },
    ],
    default: [],
  },
});

civilianSchema.methods.generateAuthToken = function () {
  return jwt.sign(
    { userType: "civilian", username: this.username },
    "jwtPrivateKey" // Change this to config.get("jwtPrvateKey")
  );
};

const Civilian = mongoose.model("Civilian", civilianSchema);

function validateCivilian(user) {
  return userValidationSchema.validate(user);
}

module.exports = { Civilian, validate: validateCivilian };
