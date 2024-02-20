const mongoose = require("mongoose");

function connection() {
  const connectionUrlLocal = "mongodb://localhost:27017/rapid-response";
  const connectionUrlCloud =
    "mongodb+srv://cham:Lasimdatlas2024@cluster0.iy1cxvg.mongodb.net/rapid-response?retryWrites=true&w=majority";

  mongoose
    .connect(connectionUrlCloud)
    .then(() => console.log("Connected to MongoDB Cloud.."))
    .catch((error) => console.error("Could not connect to MongoDB", error));
}

module.exports = connection;
