const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "rapidresponse.srilanka@gmail.com",
    pass: "omqk nfim hbbz srze",
  },
});

async function sendRegisterConfirmationMail(firstName, email) {
  const mailOptions = {
    from: '"Rapid Response" <rapidresponse.srilanka@gmail.com>',
    to: email,
    subject: "Welcome to Rapid Response - Your Emergency Assistance Platform",
    text: `Dear ${firstName},

Welcome to Rapid Response! 🚨
    
You're now part of a community dedicated to swift emergency assistance. With Rapid Response, you can send SOS signals, report incidents, and receive real-time alerts.
    
Explore the app, update your profile, and link emergency contacts for added safety.
    
Stay safe and connected!
    
Best regards,
Rapid Response Team`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Confirmation Mail sent");
  } catch (error) {
    console.log(error);
  }
}

module.exports = { sendRegisterConfirmationMail };
