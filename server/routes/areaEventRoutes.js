const express = require("express");
const router = express.Router();
const { AreaEvent, validate } = require("../models/areaEvent"); // Assuming your model

// Update the endpoint to match the URL used in the frontend
router.post("/create-area-event", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const newEvent = new AreaEvent({
      eventType: req.body.eventType,
      eventDate: req.body.eventDate,
      eventTime: req.body.eventTime,
      description: req.body.description,
      imageUrl: req.body.imageUrl, // Assuming image URL is present
    });

    await newEvent.save();
    res.status(201).send("Area event created successfully");
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

module.exports = router;

