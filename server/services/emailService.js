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
    from: '"Rapid Response" <rapidresponse.srilanka@gmail.com>',
    to: "lasithachandrasekara@gmail.com",
    subject: " Welcome to Rapid Response - Your Emergency Assistance App!",
    text: `Dear [User's Name],

    Welcome to Rapid Response, your reliable companion in times of emergency. We're thrilled to have you on board, and we want to extend a warm welcome to our community.
    
    Rapid Response is designed to provide you with swift assistance and support during critical situations. Whether you're a civilian seeking help or a first responder offering aid, our platform is here to connect you with the resources and assistance you need.
    
    As a registered user, you now have access to a range of features that empower you to respond effectively to emergencies:
    
    SOS Functionality: With just a few taps, you can send out an emergency distress signal, notifying nearby first responders and your designated emergency contacts.
    
    Incident Reporting: Easily report incidents and emergencies in your area, providing crucial information to responders and fellow users.
    
    Real-time Alerts: Stay informed about incidents and alerts in your vicinity, ensuring you're aware of any emergencies as they unfold.
    
    User Account Management: Keep your profile up-to-date with important information, ensuring that responders can reach you when needed most.
    
    Emergency Contact Linking: Connect with family members, friends, or trusted contacts to keep them informed and involved in your safety network.
    
    We encourage you to explore the app, familiarize yourself with its features, and reach out if you have any questions or feedback. Your safety and well-being are our top priorities, and we're committed to providing you with the support you need, when you need it.
    
    Thank you for joining us on this journey to make our communities safer and more resilient. Together, we can make a difference.
    
    Stay safe,
    
    [Your Name]
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
