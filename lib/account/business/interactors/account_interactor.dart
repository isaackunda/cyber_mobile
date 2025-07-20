import 'package:cyber_mobile/account/business/interactors/login_usecase.dart';
import 'package:cyber_mobile/account/business/interactors/otp_login_usecase.dart';
import 'package:cyber_mobile/account/business/interactors/verify_otp_and_register_usecase.dart';
import 'package:cyber_mobile/account/business/interactors/register_account_usecase.dart';
import 'package:cyber_mobile/account/business/interactors/register_email_usecase.dart';
import 'package:cyber_mobile/account/business/service/account_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_interactor.g.dart';

class AccountInteractor {
  LoginUseCase loginUseCase;
  RegisterAccountUseCase registerAccountUseCase;
  VerifyOtpAndRegisterUseCase verifyOtpAndRegisterUseCase;
  RegisterEmailUseCase registerEmailUseCase;
  OtpLoginUseCase otpLoginUseCase;

  AccountInteractor._(
    this.loginUseCase,
    this.registerAccountUseCase,
    this.verifyOtpAndRegisterUseCase,
    this.registerEmailUseCase,
    this.otpLoginUseCase,
  );

  static AccountInteractor build(AccountService service) {
    return AccountInteractor._(
      LoginUseCase(service),
      RegisterAccountUseCase(service),
      VerifyOtpAndRegisterUseCase(service),
      RegisterEmailUseCase(service),
      OtpLoginUseCase(service),
    );
  }
}

@Riverpod(keepAlive: true)
AccountInteractor accountInteractor(Ref ref) {
  throw Exception(
    "This method should not be called directly. Use CompteInteractor.build() instead.",
  );
}
