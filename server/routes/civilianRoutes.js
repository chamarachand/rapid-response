const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { Civilian, validate } = require("../models/civilian");

// Get
router.get("/", (req, res) => {
  res.send("This is civilian api");
});

//Post
router.post("/", async (req, res) => {
  try {
    console.log(req.body);
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    let user = await Civilian.findOne({ username: req.body.username });
    if (user)
      return res
        .status(400)
        .send("User with the given username already exists");

    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);

    res.send({ salt, hashPassword });
  } catch (error) {
    console.log(error);
  }
});

module.exports = router;
