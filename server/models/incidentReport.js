const mongoose = require("mongoose");

const incidentReportSchema = new mongoose.Schema({
  victimId: { type: mongoose.Schema.Types.ObjectId, required: true },
  location: { type: String },
  image: { type: String, maxlength: 1024 },
  voice: { type: String },
  description: { type: String, maxlength: 9048 },
  timeStamp: { type: Date },
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
