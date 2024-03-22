const mongoose = require("mongoose");
const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);

const incidentReportSchema = new mongoose.Schema({
  victimId: { type: mongoose.Schema.Types.ObjectId, required: true },
  eventType: { type: String, maxlength: 128 },
  location: { type: Object },
  image: { type: String, maxlength: 1024 },
  voice: { type: String },
  description: { type: String, maxlength: 9048 },
  timeStamp: { type: Date, default: Date.now() },
  directedTo: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
});

const IncidentReport = mongoose.model("IncidentReport", incidentReportSchema);

function validateIncidentReport(incidentReport) {
  const schema = Joi.object({
    victimId: Joi.objectId().required(),
    eventType: Joi.string().max(128).allow(""),
    location: Joi.object(),
    image: Joi.string().max(1024).allow(""),
    voice: Joi.string().allow(""),
    description: Joi.string().max(9048).allow(""),
    timeStamp: Joi.date(),
  });

  return schema.validate(incidentReport);
}

module.exports = { IncidentReport, validate: validateIncidentReport };
