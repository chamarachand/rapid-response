const express = require("express");
const router = express.Router();
const { Civilian } = require("../models/civilian");
const { RegisterLocation, validate } = require("../models/registeredLocations");

router.post("/create-registered-location", async (req, res) => {
  const { addedBy, locationTag, address, latitude, longitude } = req.body;

  // Validate if required fields are present
  if (!addedBy) {
    return res.status(400).send("Missing required fields id");
  } else if (!locationTag) {
    return res.status(400).send("Missing required fields locTag");
  } else if (!address) {
    return res.status(400).send("Missing required fields address");
  } else if (!latitude || !longitude) {
    return res.status(400).send("Missing required fields lat long");
  }

  try {
    const RegisteredLocation = new RegisterLocation({
      addedBy,
      locationTag,
      address,
      latitude,
      longitude,
    });

    await RegisteredLocation.save();

    const registeredLocationId = RegisteredLocation._id;

    const updatedUser = await Civilian.findByIdAndUpdate(
      addedBy,
      { $push: { registeredLocationsArray: registeredLocationId } },
      { new: true }
    );
    if (!updatedUser)
      return res.status(404).send("User with the given id not found");

    res.status(201).send("New Location Successfully Registered.");
  } catch (error) {
    console.error(error);
    return res.status(500).send("Internal server error");
  }
});

router.get("/registered-locations/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;

    const user = await Civilian.findById(userId);

    if (!user) {
      return res.status(404).send("User not found");
    }

    const registeredLocations = await RegisterLocation.find({
      addedBy: userId,
    });

    res.json(registeredLocations);
  } catch (error) {
    console.error(error);
    return res.status(500).send("Internal server error");
  }
});

module.exports = router;
