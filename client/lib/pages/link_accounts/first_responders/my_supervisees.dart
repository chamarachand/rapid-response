import 'package:client/pages/link_accounts/common/my_accounts.dart';

class MySupervisees extends MyAccounts {
  const MySupervisees({super.key})
      : super(
          "Supervisee", // displayName
          "first-responder", // userType
          "supervisee-remove", //notificationType
          "supervisee", // endpoint
        );
}
