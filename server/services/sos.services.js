const sosModel = require('../models/sos.model')

class sosService{
    static async assignSOS(image, voice, emergencyType, location){
        try{
            const createSOS = new sosModel({image, voice, emergencyType, location});
            return await createSOS.save();
        }catch(err){
            throw err;
        }
    }
}

module.exports = sosService;