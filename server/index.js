const express = require("express");
const app = express();
const connection = require("./database");

// Database connection
connection();

// Middleware

// Connecting to the port
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening to port ${port}..`));
