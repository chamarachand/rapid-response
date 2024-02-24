const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "chamaquarium@gmail.com",
    pass: "mkxv fbfn tipy viqs",
  },
});

async function sendRegisterConfirmationMail() {
  const mailOptions = {
    from: '"Cham Aquarium2" <chamaquarium2@gmail.com>',
    to: "lasithachandrasekara@gmail.com",
    subject: "Registration Confirmed!",
    text: "You have been registered successfully!",
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Confirmation Mail sent");
  } catch (error) {
    console.log(error);
  }
}

module.exports = { sendRegisterConfirmationMail };
