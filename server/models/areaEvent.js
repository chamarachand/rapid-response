const mongoose = require("mongoose");
const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);

const areaEventSchema = new mongoose.Schema({
  addedBy: { type: mongoose.Schema.Types.ObjectId, required: true },
  eventType: { type: String, minlength: 3, maxlength: 255, required: true },
  date: { type: Date, required: true },
  time: { type: Date, required: true },
  image: { type: String, maxlength: 1024 },
  location: { type: String, required: true },
  description: { type: String, maxlength: 9048 },
});

const AreaEvent = mongoose.model("AreaEvent", areaEventSchema);

function validateAreaEvent(areaEvent) {
  const schema = Joi.object({
    addedBy: Joi.objectId().required(),
    eventType: Joi.string().min(3).max(255).required(),
    date: Joi.date().required(),
    time: Joi.date().required(),
    image: Joi.string().max(1024).allow(""),
    location: Joi.string().required(),
    description: Joi.string().max(9048),
  });

  return schema.validate(areaEvent);
}

module.exports = { AreaEvent, validate: validateAreaEvent };
