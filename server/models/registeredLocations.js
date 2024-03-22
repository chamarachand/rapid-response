const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");

const registeredLocationsSchema = new mongoose.Schema({
    addedBy: { type: mongoose.Schema.Types.ObjectId, required: true },
    locationTag: { type: String, required: true },
    address: { type: String, required: true },
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
});

const RegisterLocation = mongoose.model("Registered Location", registeredLocationsSchema);

function validateRegisteredLocation(RegisterLocation) {
    const schema = Joi.object({
        addedBy: Joi.objectId().required(),
        locationTag: Joi.string().required(),
        address: Joi.string().required(),
        latitude: Joi.Number().required(),
        longitude: Joi.Number().required(),
    });
  
    return schema.validate(RegisterLocation);
  }
  
  module.exports = { RegisterLocation, validate:  validateRegisteredLocation};

