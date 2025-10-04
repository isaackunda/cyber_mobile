import '../models/register_request.dart';

abstract class AccountService {
  Future<dynamic> login(String phone);
  Future<dynamic> registerEmail(String phone);
  Future<dynamic> registerAccount(RegisterRequest data);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<dynamic> verifyOtpAndRegister(String phone, String otp);
  Future<dynamic> otpLogin(String phone, String otp);
}