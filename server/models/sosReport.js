const mongoose = require("mongoose");

const sosReportSchema = new mongoose.Schema({
  id: { type: String, required: true },
  image: { type: String },
  voice: { type: String },
  emergencyType: { type: String, required: true },
  location: { type: Object, required: true },
  date: {type: String, required: true}, // Assuming location is a GeoJSON object
});

const SOSReport = mongoose.model("SOSReport", sosReportSchema);

module.exports = {SOSReport};