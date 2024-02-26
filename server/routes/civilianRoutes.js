const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { sendRegisterConfirmationMail } = require("../services/emailService");
const { Civilian, validate } = require("../models/civilian");

// Get
router.get("/", (req, res) => {
  res.send("This is civilian api");
});

router.get("/search", async (req, res) => {
  try {
    const serachTerm = req.query.username;
    const users = await Civilian.find({
      username: { $regex: serachTerm, $options: "i" },
    });

    if (users.length === 0) return res.status(404).send("No users found");

    res.send(users);
  } catch (error) {
    res.status(500).send("Internal server error");
  }
});

router.get("/checkUser/:username", async (req, res) => {
  try {
    const username = req.params.username;

    const civilian = await Civilian.findOne({ username });

    if (civilian)
      res.status(400).json({
        userExists: true,
        message: "A user with the given id already exists",
      });
    else
      res
        .status(200)
        .json({ userExists: false, message: "User does not exist" });
  } catch (error) {
    res.status(500).send("Internal server error");
  }
});

//Post
router.post("/", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    let user = await Civilian.findOne({ username: req.body.username });
    if (user)
      return res
        .status(400)
        .send("Civilian user with the given username already exists");

    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);

    user = new Civilian({ ...req.body, password: hashPassword });
    await user.save();
    sendRegisterConfirmationMail(user.firstName, user.email);
    res.status(201).send("Civilian user registered successfully!"); // we can send  the user as well
  } catch (error) {
    console.log(error);
    res.status(500).send("Internal Server Error");
  }
});

module.exports = router;
