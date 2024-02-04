const mongoose = require("mongoose");
const { User } = require("./user");

const civilianSchema = new mongoose.Schema();

const Civilian = User.discriminator("Civilian", civilianSchema);

module.exports = Civilian;
