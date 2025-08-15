// utils/user_session.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class UserSession {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getters
  static bool isLoggedIn() => _prefs.getBool('isLoggedIn') == true;
  static String? getUserId() => _prefs.getString('userId');
  static String? getPhone() => _prefs.getString('phone');
  static String? getDeviceId() => _prefs.getString('deviceId');
  static String? getOsType() => _prefs.getString('osType');
  static String? getAuthToken() => _prefs.getString('authToken');

  // Optional: Logout method
  static Future<void> logout() async {
    await _prefs.setBool('isLoggedIn', false);
    // Don't remove device/os if needed for re-login, otherwise clear selectively
  }

  //================================================================================================================

  // ✅ Save agenda
  static Future<void> saveAgenda(List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = sessions.map((s) => s.toMap()).toList();
    await prefs.setString('userAgenda', jsonEncode(jsonList));
  }

  // ✅ Load agenda
  static Future<List<Session>> loadAgenda() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userAgenda');
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) => Session.fromMap(item)).toList();
  }

  // ✅ Clear agenda (optional)
  static Future<void> clearAgenda() async {
    final prefs = await SharedPreferences.getInstance();
  }

  //===============================================================================================

  // Save draft question
  static Future<void> saveQuestionDraft(String draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('questionDraft', draft);
  }

  static Future<String?> loadQuestionDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('questionDraft');
  }

  // Save voted polls
  static Future<void> recordPollVote(String pollId) async {
    final prefs = await SharedPreferences.getInstance();
    final voted = prefs.getStringList('votedPolls') ?? [];
    if (!voted.contains(pollId)) {
      voted.add(pollId);
      await prefs.setStringList('votedPolls', voted);
    }
  }

  static Future<bool> hasVoted(String pollId) async {
    final prefs = await SharedPreferences.getInstance();
    final voted = prefs.getStringList('votedPolls') ?? [];
    return voted.contains(pollId);
  }
}
