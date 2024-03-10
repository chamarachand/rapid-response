const express = require("express");
const router = express.Router();
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");

// Get the list of emergency contacts of a particular user
router.get("/emergency-contacts/:userId", async (req, res) => {
  const { userId } = req.params;
  if (!userId) return res.status(400).send("Bad request");

  try {
    const { emergencyContacts } = await Civilian.findById(userId)
      .select("emergencyContacts")
      .populate({
        path: "emergencyContacts",
        select: "firstName lastName phoneNumber email",
      });

    if (!emergencyContacts || emergencyContacts.length === 0)
      return res.status(404).send("No emergency contacts");

    return res.status(200).send(emergencyContacts);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

// Check if the inteded user is already an emergency contact
router.get(
  "/emergency-contacts/:currentUserId/:intendedUserId",
  async (req, res) => {
    const { currentUserId, intendedUserId } = req.params;

    if (!currentUserId || !intendedUserId)
      return res.status(400).send("Missing parameter/s");

    const currentUser = await Civilian.findById(currentUserId).select(
      "emergencyContacts"
    );

    if (!currentUser)
      return res.status(400).send("User with given id not found");

    const isEmergencyContact =
      currentUser.emergencyContacts.includes(intendedUserId);

    return isEmergencyContact
      ? res.status(200).send("Intended user is already an emergency contact")
      : res.status(404).send("Intended user is not an emergency contact");
  }
);

// Add the current user as an emergency contact of the requested user
router.patch(
  "/emergency-contacts/add/:currentUserId/:requestedUserId",
  async (req, res) => {
    const { currentUserId, requestedUserId } = req.params;

    try {
      if (!currentUserId || !requestedUserId)
        return res.status(400).send("Bad Request");

      // Can add validations for checking the userId is valid ObjectId

      const updatedUser = await Civilian.findByIdAndUpdate(
        requestedUserId,
        { $push: { emergencyContacts: currentUserId } },
        { new: true }
      );

      if (!updatedUser)
        return res.status(404).send("User with the given id not found");

      res.status(200).send("Emergency contact added successfully");
    } catch (error) {
      console.log("Error: " + error);
      res.status(500).send("Internal server error");
    }
  }
);

// First Responders

// Check if the inteded user is already a supervisee
router.get("/supervisee/:currentUserId/:intendedUserId", async (req, res) => {
  const { currentUserId, intendedUserId } = req.params;

  if (!currentUserId || !intendedUserId)
    return res.status(400).send("Bad Request");

  const currentUser = await FirstResponder.findById(currentUserId).select(
    "superviseeAccounts"
  );

  if (!currentUser) return res.status(400).send("User with given id not found");

  const isSupervisee = currentUser.superviseeAccounts.includes(intendedUserId);

  return isSupervisee
    ? res.status(200).send("Intended user is already a supervisee")
    : res.status(404).send("Intended user is not a supervisee");
});

module.exports = router;
