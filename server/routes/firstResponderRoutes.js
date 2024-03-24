const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { FirstResponder, validate } = require("../models/first-responder");
const authMiddleware = require("../middleware/authMiddleware");
const { mongo, default: mongoose } = require("mongoose");
const { sendRegisterConfirmationMail } = require("../services/emailService");

// Get
router.get("/", (req, res) => {
  res.send("This is first responder api");
});

router.get("/search", authMiddleware, async (req, res) => {
  try {
    const searchTerm = req.query.username;
    if (searchTerm === "") return res.send([]);

    const currentUserId = req.user.id;
    if (!currentUserId) return res.status(400).send("Bad request");

    const users = await FirstResponder.find({
      $and: [
        { _id: { $ne: currentUserId } }, // Exclude current user
        { username: { $regex: searchTerm, $options: "i" } },
      ],
    }).select("firstName lastName username profilePic");

    if (users.length === 0) return res.status(404).send("No users found");

    res.send(users); // Change this to send only necessary details
  } catch (error) {
    res.status(500).send("Internal server error");
  }
});

router.post("/", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    let user = await FirstResponder.findOne({ username: req.body.username });
    if (user)
      return res
        .status(400)
        .send("First responder user with the given username already exists");

    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);

    user = new FirstResponder({ ...req.body, password: hashPassword });
    await user.save();
    sendRegisterConfirmationMail(user.firstName, user.email);
    res.status(201).send("First responder user registered successfully!"); // we can send  the user as well
  } catch (error) {
    console.log(error);
    res.status(500).send("Internal Server Error");
  }
});

//Sahan's code below
// Link - http://10.0.2.2:3000/api/first-responder/get-availability
router.get("/get-availability", authMiddleware, async (req, res) => {
  try {
    const { id } = req.user;
    const firstResponder = await FirstResponder.findById(id).select(
      "availability"
    );
    console.log(firstResponder);

    if (!firstResponder)
      return res.status(404).send("FirstResponder not found");

    res.status(200).send({ availability: firstResponder.availability });
  } catch (error) {
    console.error("Error getting availability:", error);
    res.status(500).send("Internal Server Error");
  }
});

// Link - http://10.0.2.2:3000/api/first-responder/set-availability?availability=true
router.patch("/set-availability", authMiddleware, async (req, res) => {
  console.log("Reached");
  try {
    const { id } = req.user;
    const { availability } = req.query;

    if (!availability) {
      return res.status(400).send("Invalid availability value");
    }

    const firstResponder = await FirstResponder.findByIdAndUpdate(
      id,
      { availability: availability },
      { new: true }
    );

    if (!firstResponder)
      return res.status(404).send("FirstResponder not found");

    res.status(200).send({
      message: "Availability updated successfully",
      availability: firstResponder.availability,
    });
  } catch (error) {
    console.error("Error updating availability:", error);
    res.status(500).send("Internal Server Error");
  }
});

router.get("/get-latitude-longitude", authMiddleware, async (req, res) => {
  try {
    const { id } = req.user;
    const firstResponder = await FirstResponder.findById(id).select(
      "latitude longitude"
    );
    console.log(firstResponder);

    if (!firstResponder)
      return res.status(404).send("FirstResponder not found");

    res.status(200).send({ availability: firstResponder.availability });
  } catch (error) {
    console.error("Error getting availability:", error);
    res.status(500).send("Internal Server Error");
  }
});


// Link - http://10.0.2.2:3000/api/first-responder/set-latitude-longitude?latitude=valueHere&longitude=valueHere
router.patch("/set-latitude-longitude", authMiddleware, async (req, res) => {
  console.log("Reached");
  try {
    const { id } = req.user;
    const { latitude, longitude } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).send("Invalid latitude or longitude value");
    }

    const firstResponder = await FirstResponder.findByIdAndUpdate(
      id,
      { latitude: latitude, longitude: longitude },
      { new: true }
    );

    if (!firstResponder)
      return res.status(404).send("FirstResponder not found");

    res.status(200).send({
      message: "Latitude Longitude updated successfully",
      availability: firstResponder.availability,
    });
  } catch (error) {
    console.error("Error updating Latitude Longitude", error);
    res.status(500).send("Internal Server Error");
  }
});

//Delete
router.delete(
  "/remove/supervisee/:superviseeId",
  authMiddleware,
  async (req, res) => {
    const userId = req.user.id;
    const { superviseeId } = req.params;

    if (!userId || !superviseeId) return res.status(400).send("Bad Request");

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const removeSupervisee = await FirstResponder.updateOne(
        { _id: userId },
        { $pull: { superviseeAccounts: superviseeId } }
      );

      const removeSupervisor = await FirstResponder.updateOne(
        { _id: superviseeId },
        { $pull: { supervisorAccounts: userId } }
      );

      if (
        removeSupervisee.modifiedCount === 0 ||
        removeSupervisor.modifiedCount === 0
      ) {
        await session.abortTransaction();
        session.endSession();
        return res
          .status(404)
          .send("Supervisee account with the given id not found for the user");
      }

      await session.commitTransaction();
      session.endSession();

      return res.status(200).send("Emergency contact removed successfully");
    } catch (error) {
      console.log("Error: " + error);
      return res.status(500).send("Internal Server Error");
    }
  }
);

module.exports = router;
