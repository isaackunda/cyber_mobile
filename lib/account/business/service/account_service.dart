import '../models/register_request.dart';

abstract class AccountService {
  Future<dynamic> login(String email);
  Future<dynamic> registerEmail(String email);
  Future<dynamic> registerAccount(RegisterRequest data);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<dynamic> verifyOtpAndRegister(String email, String otp);
  Future<dynamic> otpLogin(String email, String otp);
}