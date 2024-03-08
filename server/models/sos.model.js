const mongoose = require('mongoose');
const dataBase = require('../database');

const {Schema} = mongoose;


const sosSchema = new Schema({
    image:{
        type: String,
    },
    voice:{
        type: String,
    },
    emergency:{
        type: String,
        required: true,
        lowercase: true
    },
    location:{
        type: String,
        required: true
    }
});

const sosReportModel = dataBase.model('sosReport', sosSchema);

module.exports = sosReportModel;