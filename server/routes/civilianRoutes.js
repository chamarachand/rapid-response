const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { Civilian, validate } = require("../models/civilian");
const { User } = require("../models/user");

// Get
router.get("/", (req, res) => {
  res.send("This is civilian api");
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
        .send("User with the given username already exists");

    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);

    user = new Civilian({ ...req.body, password: hashPassword });
    await user.save();
    res.status(201).send("User registered successfully!"); // we can send  the user as well
  } catch (error) {
    res.status(500).send("Internal Server Error");
  }
});

module.exports = router;
