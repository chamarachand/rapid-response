const express = require('express');
const router = express.Router();
const { IncidentReport } = require("../models/incidentReport");
const { SOSReport, SOSReport, SOSReport } = require("../models/sosReport");
//const { Civilian } = require("../models/civilian");
// const incidentReport = require('../models/incidentReport');
const { route } = require('./civilianRoutes');

//api/posts/incidents
router.get("/incidents", async (req, res) => {
    try {
        const incidentPost = await IncidentReport.find();
        res.status(200).send(incidentPost);
    } catch (error) {
        console.error(error);
        res.status(500).send("Internal server error.");
    }
});

router.get("/sos", async (req, res) => {
    try {
        const SOSReport = await SOSReport.find();
        res.status(200).send(SOSReport);
    } catch (error) {
        console.error(error);
        res.status(500).send("Internal server error.");
    }
}
);

module.exports = router;