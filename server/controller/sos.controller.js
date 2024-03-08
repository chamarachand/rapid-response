const sosService = require("../services/sos.services");


exports.createSOS = async(req, res, next) => {
    try {
        const {image, voice, emergencyType, location} = req.body;

        const successRes = await sosService.assignSOS(image, voice, emergencyType, location);

        res.json({status:true, success: "SOS assigned successfully"})
    } catch (error) {
        throw error;
    }
}