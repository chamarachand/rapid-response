import 'package:client/pages/link_accounts/common/my_accounts.dart';

class MyEmergencyContacts extends MyAccounts {
  const MyEmergencyContacts({super.key})
      : super(
          "Emergency Contact", // displayName
          "civilian", // userType
          "emergency-contact-remove", //notificationType
          "emergency-contact", // endpoint
        );
}
