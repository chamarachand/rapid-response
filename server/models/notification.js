const mongoose = require("mongoose");
const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);

const notificationSchema = new mongoose.Schema({
  from: { type: mongoose.Schema.Types.ObjectId },
  to: { type: mongoose.Schema.Types.ObjectId, required: true },
  title: { type: String },
  body: { type: String },
  timestamp: { type: Date },
});

const Notification = mongoose.model("Notification", notificationSchema);

function validate(notification) {
  const schema = Joi.object({
    from: Joi.objectId(),
    to: Joi.objectId().required(),
    title: Joi.string().required(),
    body: Joi.string().required(),
  });
  return schema.validate();
}

module.exports = { Notification, validate };
