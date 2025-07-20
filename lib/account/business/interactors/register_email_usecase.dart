import 'package:cyber_mobile/account/business/service/account_service.dart';

class RegisterEmailUseCase {
  final AccountService _accountService;

  RegisterEmailUseCase(this._accountService);

  Future<dynamic> execute(String email) {
    return _accountService.registerEmail(email);
  }
}