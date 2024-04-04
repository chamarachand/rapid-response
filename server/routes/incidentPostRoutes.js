const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware");
const { IncidentReport } = require("../models/incidentReport");
const { SOSReport } = require("../models/sosReport");
const { FirstResponder } = require("../models/first-responder");

//api/posts/incidents
router.get("/incidents/latest", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  if (!userId) return res.status(400).send("Bad Request");

  try {
    const { incidentReports } = await FirstResponder.findById(userId)
      .select("incidentReports")
      .populate({
        path: "incidentReports",
        model: "IncidentReport",
        options: { sort: { timeStamp: -1 } },
      })
      .limit(15);
    return res.status(200).send(incidentReports);
  } catch (error) {
    console.error(error);
    return res.status(500).send("Internal server error.");
  }
});

router.get("/sos/latest", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  if (!userId) return res.status(400).send("Bad Request");

  try {
    const { sosReports } = await FirstResponder.findById(userId)
      .select("sosReports")
      .populate({
        path: "sosReports",
        model: "SOSReport",
      });
    res.status(200).send(sosReports.reverse());
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal server error.");
  }
});

module.exports = router;
