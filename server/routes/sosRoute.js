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

const express = require("express");
const router = express.Router();

router.post("/", async (req, res) => {
  console.log("Reached");
  const { id, image, voice, emergencyType, location, date } = req.body;

  try {
    const newSOSReport = new SOSReport({
      id,
      image,
      voice,
      emergencyType,
      location,
      date
    });

    await newSOSReport.save();

    res.json({ message: "SOS report created successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error creating SOS report" });
  }
});

module.exports = router;
