const express = require("express");
const router = express.Router();
const { IncidentReport } = require("../models/incidentReport");
const { SOSReport } = require("../models/sosReport");

//api/posts/incidents
router.get("/incidents/latest", async (req, res) => {
  try {
    const latestIncident = await IncidentReport.find().sort({ createdAt: 1 }); //-1 for descending order
    res.status(200).send(latestIncident.reverse());
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal server error.");
  }
});

router.get("/sos/latest", async (req, res) => {
  try {
    const latestSOS = await SOSReport.find().sort({ createdAt: 1 }).limit(3);
    res.status(200).send(latestSOS.reverse());
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal server error.");
  }
});

module.exports = router;

