const express = require("express");
const router = express.Router();
const { RegisterLocation, validate } = require("../models/registeredLocations");

router.post("/create-registered-location", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const RegisteredLocation = new RegisterLocation({ ...req.body });
    RegisteredLocation.save();
    res.status(201).send("New Location Successfully Registered.");
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal server error");
  }
});

module.exports = router;
