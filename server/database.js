const mongoose = require("mongoose");

function connection() {
  const connectionUrl = "mongodb://localhost:27017/rapid-response";

  mongoose
    .connect(connectionUrl)
    .then(() => console.log("Connected to MongoDB.."))
    .catch((error) => console.error("Could not connect to MongoDB", error));
}

module.exports = connection;
