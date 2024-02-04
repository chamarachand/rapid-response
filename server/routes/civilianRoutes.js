const express = require("express");
const router = express.Router();
const { Civilian, validate } = require("../models/civilian");

// Get
router.get("/", (req, res) => {
  res.send("This is civilian api");
});

module.exports = router;
