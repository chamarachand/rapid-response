const express = require("express");
const app = express();
const connection = require("./database");
const civilianRoutes = require("./routes/civilianRoutes");
const firstResponderRoutes = require("./routes/firstResponderRoutes");
const nicValidateRoutes = require("./routes/nicValidator");
const notificationRoutes = require("./routes/notificationRoutes");
const linkedAccountRoutes = require("./routes/linkedAccountRoutes");
const auth = require("./routes/auth");
//const sosReport = require("./models/sos.model");

// Database connection
connection();

// Middleware
app.use(express.json());
app.use("/api/auth", auth);
app.use("/api/civilian", civilianRoutes);
app.use("/api/first-responder", firstResponderRoutes);
app.use("/api/validate-nic", nicValidateRoutes);
app.use("/api/notification", notificationRoutes);
app.use("/api/linked-accounts", linkedAccountRoutes);
//app.use("/api/sos-Report", sosReport);

// Connecting to the port
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening to port ${port}..`));
