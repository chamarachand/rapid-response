const router = require('express').Router();
const sosController = require("../controller/sos.controller");

router.post('/sosAssign', sosController.createSOS);

module.exports = router;