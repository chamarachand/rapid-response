const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { FirstResponder, validate } = require("../models/first-responder");
const authMiddleware = require("../middleware/authMiddleware");
const { mongo, default: mongoose } = require("mongoose");

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
        { $pull: { superviseeAccounts: superviseeId } },
        { session }
      );

      const removeSupervisor = await FirstResponder.updateOne(
        { _id: superviseeId },
        { $pull: { supervisorAccounts: userId } },
        { session }
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
