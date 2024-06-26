const express = require("express");
const app = express();
const connection = require("./database");
const auth = require("./routes/auth");
const civilianRoutes = require("./routes/civilianRoutes");
const firstResponderRoutes = require("./routes/firstResponderRoutes");
const nicValidateRoutes = require("./routes/nicValidator");
const notificationRoutes = require("./routes/notificationRoutes");
const linkedAccountRoutes = require("./routes/linkedAccountRoutes");
const sosRoutes = require("./routes/sosRoute");
const incidentReportRoutes = require("./routes/incidentReportRoutes");
const areaEventRoutes = require("./routes/areaEventRoutes");
const profilePicRoutes = require("./routes/profilePicRoutes");
const incidentPostRoutes = require("./routes/incidentPostRoutes");
const registeredLocationsRoutes = require("./routes/registeredLocationsRoutes");

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
app.use("/api/sos-report", sosRoutes);
app.use("/api/incident-report", incidentReportRoutes);
app.use("/api/area-event", areaEventRoutes);
app.use("/api/profile-pic", profilePicRoutes);
app.use("/api/posts", incidentPostRoutes);
app.use("/api/registeredLocations", registeredLocationsRoutes);

// Connecting to the port
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening to port ${port}..`));
