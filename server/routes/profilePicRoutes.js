const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");

router.get("/profile-pic-url", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  if (!userId) return res.status(400).send("Bad Request");

  const [civilian, firstResponder] = await Promise.all([
    Civilian.findById(userId).select("profilePic"),
    FirstResponder.findById(userId).select("profilePic"),
  ]);

  const user = civilian || firstResponder;
  if (!user) return res.status(404).send("A user with the given id not found");

  const { profilePic } = user;
  if (!profilePic)
    return res
      .status(404)
      .send("Profile picture url for the given user not found");

  return res.status(200).send(profilePic);
});

module.exports = router;
