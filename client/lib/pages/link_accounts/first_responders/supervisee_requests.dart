import 'package:client/pages/link_accounts/common/requests.dart';

class SuperviseeRequests extends Requests {
  const SuperviseeRequests({super.key})
      : super(
          "Supervisee",
          "supervisee-request",
          "supervisee-request-accept",
          "supervisee-accounts",
        );
}
