import 'package:client/pages/link_accounts/common/requests.dart';

class EmergencyContactRequests extends Requests {
  const EmergencyContactRequests({super.key})
      : super(
          "Emergency Contact",
          "emergency-contact-request",
          "emergency-contact-request-accept",
          "emergency-contacts",
        );
}
