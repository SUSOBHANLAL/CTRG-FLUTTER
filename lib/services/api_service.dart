// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/models/contact_data.dart';
import 'package:my_flutter_app/models/event.dart';
import 'package:my_flutter_app/models/home_data.dart';
import 'package:my_flutter_app/models/schedule_data.dart';
import 'package:my_flutter_app/models/user_response.dart';
import 'package:my_flutter_app/models/venue_data.dart';
import 'package:my_flutter_app/utils/constants.dart';

class ApiService {
  Future<HomeData> getHomeData() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.homeEndpoint}'),
    );
    if (response.statusCode == 200) {
      return HomeData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load home data');
    }
  }

  // Future<List<ScheduleData>> getScheduleData() async {
  //   final response = await http.get(
  //     Uri.parse('${Constants.baseUrl}${Constants.scheduleEndpoint}'),
  //   );
  //   if (response.statusCode == 200) {
  //     List<dynamic> schedules = json.decode(response.body);
  //     return schedules
  //         .map((schedule) => ScheduleData.fromJson(schedule))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load schedule data');
  //   }
  // }

  Future<List<Schedule>> getScheduleData() async {
    // <-- Changed to Schedule
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.scheduleEndpoint}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> schedules = json.decode(response.body);
      return schedules
          .map((item) => Schedule.fromJson(item)) // <-- Use Schedule.fromJson
          .toList();
    } else {
      throw Exception('Failed to load schedule data');
    }
  }

  Future<List<VenueData>> getVenueData() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.venuesEndpoint}'),
    );
    if (response.statusCode == 200) {
      List<dynamic> venues = json.decode(response.body);
      return venues.map((venue) => VenueData.fromJson(venue)).toList();
    } else {
      throw Exception('Failed to load venue data');
    }
  }

  Future<ContactData> getContactData() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.contactEndpoint}'),
    );
    if (response.statusCode == 200) {
      return ContactData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load contact data');
    }
  }

  // lib/services/api_service.dart

  Future<List<Event>> getEventsByScheduleId(String scheduleId) async {
    final url = Uri.parse('https://tutem.in/api5/auth/events-by-schedule');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'scheduleId': scheduleId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> eventData = json.decode(response.body)['data'];
      return eventData.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events for schedule $scheduleId');
    }
  }

  // ✅ ADDED: Register with OTP method
  Future<Map<String, dynamic>> registerWithOtp({
    required String name,
    required String phone,
    String? address,
    String? dateOfBirth,
    String? gender,
    String? userRole,
    String? deviceId,
    String? ostype,
    String? password,
    String? confirmPassword,
  }) async {
    final url = Uri.parse(
      '${Constants.baseUrl}${Constants.registerWithOtpEndpoint}',
    );

    final body = {
      'name': name,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'userRole': userRole,
      'deviceId': deviceId,
      'ostype': ostype,
      'password': password,
      'confirmPassword': confirmPassword,
    };

    // Remove null values from body
    body.removeWhere((key, value) => value == null);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Registration failed');
    }
  }

  // 🔍 Search user by phone number
  Future<UserResponse> searchUserByPhone(String phone) async {
    final url = Uri.parse('${Constants.baseUrl}/searchUserusingphoneNo');

    final body = {"phone": phone};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return UserResponse.fromJson(jsonMap);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to search user');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

// In your api_service.dart
Future<Map<String, dynamic>> loginWithOtp({
  required String phone,
  required String otp,
  required String deviceId,
  required String osType,
}) async {
  final url = Uri.parse(
    '${Constants.baseUrl}${Constants.loginWithOtpEndpoint}',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'phone': phone,
      'otp': otp,
      'deviceId': deviceId,
      'osType': osType.toLowerCase(),
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Login failed');
  }
}

// Resend OTP
Future<void> resendOtp(String phone) async {
  final url = Uri.parse('${Constants.baseUrl}${Constants.resendOtpEndpoint}');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone': phone}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to resend OTP');
  }
}

// api/auth/searchUserusingphoneNo

Future<Map<String, dynamic>?> verifyOtpWithUserId(
  String userId,
  String enteredOtp,
) async {
  final url = Uri.parse(
    '${Constants.baseUrl}${Constants.verifyOtpUsingUserIdEndpoint}',
  );

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'enteredOtp': enteredOtp}),
    );

    // ✅ Parse the response body
    final decodedBody = jsonDecode(response.body);

    // ✅ Return meaningful data whether success or error
    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': decodedBody,
        'message': decodedBody['message'] ?? 'OTP verified successfully!',
      };
    } else {
      return {
        'success': false,
        'message': decodedBody['message'] ?? 'Invalid or expired OTP.',
        'status': response.statusCode,
      };
    }
  } catch (e) {
    // ✅ Handle network errors, timeouts, JSON parse errors
    return {
      'success': false,
      'message': 'Network error: Unable to connect to server.',
      'error': e.toString(),
    };
  }
}
