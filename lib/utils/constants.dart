// lib/utils/constants.dart
class Constants {
  static const String baseUrl =
      'https://tutem.in/api5/auth'; // <-- changed to new URL

  // static const String baseUrl =
  // 'http://10.0.2.2:5000/api'; // Use 10.0.2.2 for Android emulators

  static const String homeEndpoint = '/home';
  static const String scheduleEndpoint = '/getSchedule';
  static const String venuesEndpoint = '/getVenues';
  static const String contactEndpoint = '/getContact';
  static const String eventEndpoint = '/events-by-schedule';
  // ✅ Added: Register with OTP endpoint
  static const String registerWithOtpEndpoint = '/registerwithotp';
  // ✅ New: OTP Login Endpoints
  static const String loginWithOtpEndpoint = '/loginWithOtp';
  static const String resendOtpEndpoint = '/resendOtpForlogin';
  static const String searchUserusingphoneNo = '/searchUserusingphoneNo';

  static const String verifyOtpUsingUserIdEndpoint = "/verifyOtpusingUserID";
}
