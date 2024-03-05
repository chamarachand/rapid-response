const express = require("express");
const router = express.Router();
const { Civilian } = require("../models/civilian");

router.get("/emergency-contacts/:userId", async (req, res) => {
  const { userId } = req.params;
  console.log(userId);
  if (!userId) return res.status(400).send("Bad requst");

  try {
    const { emergencyContacts } = await Civilian.findById(userId)
      .select("emergencyContacts")
      .populate({
        path: "emergencyContacts",
        select: "firstName lastName phoneNumber email",
      });

    if (!emergencyContacts || emergencyContacts.length === 0)
      return res.status(404).send("No emergency contacts");

    return res.status(200).send(emergencyContacts);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

module.exports = router;
