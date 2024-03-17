const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { FirstResponder, validate } = require("../models/first-responder");
const authMiddleware = require("../middleware/authMiddleware");

// Get
router.get("/", (req, res) => {
  res.send("This is first responder api");
});

router.get("/search", authMiddleware, async (req, res) => {
  try {
    const serachTerm = req.query.username;
    if (serachTerm === "") return res.send([]);

    const users = await FirstResponder.find({
      username: { $regex: serachTerm, $options: "i" },
    });

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

module.exports = router;
