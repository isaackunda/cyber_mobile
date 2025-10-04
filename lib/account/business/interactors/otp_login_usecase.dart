import 'package:cyber_mobile/account/business/service/account_service.dart';

class OtpLoginUseCase {
  final AccountService _accountService;

  OtpLoginUseCase(this._accountService);

  Future<dynamic> execute(String phone, String otp) {
    return _accountService.otpLogin(phone, otp);
  }

}