import '../models/register_request.dart';
import '../service/account_service.dart';

class RegisterAccountUseCase {
  final AccountService _accountService;

  RegisterAccountUseCase(this._accountService);

  Future<dynamic> call(RegisterRequest data) {
    return _accountService.registerAccount(data);
  }
}
