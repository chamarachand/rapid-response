const mongoose = require("mongoose");
const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);

// const notificationSchema = new mongoose.Schema({
//   // Add min max values later
//   from: {
//     type: mongoose.Schema.Types.ObjectId,
//     ref: "FirstResponder",
//     // Later change this to baoth civilian and first responders using refPath. Then create new notifications and check
//   },
//   to: {
//     type: mongoose.Schema.Types.ObjectId,
//     required: true,
//   },
//   type: { type: String },
//   title: { type: String },
//   body: { type: String },
//   timestamp: { type: Date },
//   responded: { type: Boolean },
// });

const notificationSchema = new mongoose.Schema({
  // Add min max values later
  from: {
    type: mongoose.Schema.Types.ObjectId,
  },
  to: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  type: { type: String },
  title: { type: String },
  body: { type: String },
  timestamp: { type: Date },
  responded: { type: Boolean },
});

const Notification = mongoose.model("Notification", notificationSchema);

function validate(notification) {
  const schema = Joi.object({
    from: Joi.objectId(),
    to: Joi.objectId().required(),
    title: Joi.string().required(),
    body: Joi.string().required(),
  });
  return schema.validate(notification);
}

module.exports = { Notification, validate };
