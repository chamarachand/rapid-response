const express = require("express");
const router = express.Router();
const { FirstResponder, validate } = require("../models/first-responder"); //typo

// Get
router.get("/", (req, res) => {
  res.send("This is first responder api");
});

module.exports = router;
