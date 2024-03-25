const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware");
const { SOSReport } = require("../models/sosReport");

router.post("/", authMiddleware, async (req, res) => {
  const { id, image, voice, emergencyType, location, date } = req.body;

  try {
    const newSOSReport = new SOSReport({
      id,
      image,
      voice,
      emergencyType,
      location,
      date,
    });

    const sosReport = await newSOSReport.save();

    res.status(201).json({
      sosId: sosReport._id,
      message: "SOS report created successfully!",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error creating SOS report" });
  }
});

module.exports = router;
