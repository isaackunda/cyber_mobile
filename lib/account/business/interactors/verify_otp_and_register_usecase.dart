import 'package:cyber_mobile/account/business/service/account_service.dart';

class VerifyOtpAndRegisterUseCase {
  final AccountService _accountService;

  VerifyOtpAndRegisterUseCase(this._accountService);

  Future<dynamic> execute(String email, String otp) {
    return _accountService.verifyOtpAndRegister(email, otp);
  }
}