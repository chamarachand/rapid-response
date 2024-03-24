const express = require("express");
const router = express.Router();
const { IncidentReport, validate } = require("../models/incidentReport");

router.post("/create-incident", async (req, res) => {
  try {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const incidentReport = new IncidentReport({ ...req.body });
    const newIncidentReport = await incidentReport.save();
    res.status(201).json({
      incidentId: newIncidentReport._id,
      message: "Incident report created successfully",
    });
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal server error");
  }
});

module.exports = router;
