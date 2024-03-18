const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");

const registeredLocationsShema = new mongoose.Schema({
    addedBy: { type: mongoose.Schema.Types.ObjectId, required: true },
    locationTag: { type: String, required: true },
    address: { type: String, required: true },
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
});

const RegisterLocation = mongoose.model("Registered Location", registeredLocationsShema);

