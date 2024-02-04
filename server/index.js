const express = require("express");
const app = express();
const connection = require("./database");
const civilianRoutes = require("./routes/civilianRoutes");
const firstResponderRoutes = require("./routes/firstResponderRoutes");

// Database connection
connection();

// Middleware
app.use(express.json());
app.use("/api/civilian", civilianRoutes);
app.use("/api/first-responder", firstResponderRoutes);

// Connecting to the port
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening to port ${port}..`));
