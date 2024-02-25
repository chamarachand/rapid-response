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

async function sendRegisterConfirmationMail() {
  const mailOptions = {
    from: '"Rapid Response" <rapidresponse.srilanka@gmail.com>',
    to: "lasithachandrasekara@gmail.com",
    subject: " Welcome to Rapid Response - Your Emergency Assistance App!",
    html: `<p>Dear [User's Name],</p>

    <p>Welcome to <strong>Rapid Response</strong>, your reliable companion in times of emergency. We're thrilled to have you on board, and we want to extend a warm welcome to our community.</p>

    <p><strong>Rapid Response</strong> is designed to provide you with swift assistance and support during critical situations. Whether you're a civilian seeking help or a first responder offering aid, our platform is here to connect you with the resources and assistance you need.</p>

    <p>As a registered user, you now have access to a range of features that empower you to respond effectively to emergencies:</p>
    <ul>
        <li><strong>SOS Functionality:</strong> With just a few taps, you can send out an emergency distress signal, notifying nearby first responders and your designated emergency contacts.</li>
        <li><strong>Incident Reporting:</strong> Easily report incidents and emergencies in your area, providing crucial information to responders and fellow users.</li>
        <li><strong>Real-time Alerts:</strong> Stay informed about incidents and alerts in your vicinity, ensuring you're aware of any emergencies as they unfold.</li>
        <li><strong>User Account Management:</strong> Keep your profile up-to-date with important information, ensuring that responders can reach you when needed most.</li>
        <li><strong>Emergency Contact Linking:</strong> Connect with family members, friends, or trusted contacts to keep them informed and involved in your safety network.</li>
    </ul>

    <p>We encourage you to explore the app, familiarize yourself with its features, and reach out if you have any questions or feedback. Your safety and well-being are our top priorities, and we're committed to providing you with the support you need, when you need it.</p>

    <p>Thank you for joining us on this journey to make our communities safer and more resilient. Together, we can make a difference.</p>

    <p>Stay safe,</p>

    <p>[Your Name]<br>Rapid Response Team</p>`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Confirmation Mail sent");
  } catch (error) {
    console.log(error);
  }
}

module.exports = { sendRegisterConfirmationMail };
