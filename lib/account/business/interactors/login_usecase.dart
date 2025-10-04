import 'package:cyber_mobile/account/business/service/account_service.dart';

class LoginUseCase {
  final AccountService _accountService;

  LoginUseCase(this._accountService);

  Future<dynamic> execute(String phone) {
    return _accountService.login(phone);
  }
}