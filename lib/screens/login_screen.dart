// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:my_flutter_app/screens/login_with_otp_screen.dart';
import '../utils/constants.dart';
import 'register_screen.dart';
import 'otp_verification_screen.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _deviceId = '';
  String _osType = '';

  @override
  void initState() {
    super.initState();
    _getDeviceDetails();
  }

  // Future<void> _getDeviceDetails() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //   try {
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       _deviceId = androidInfo.id;
  //       _osType = 'android';
  //     } else {
  //       _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
  //       _osType = 'web';
  //     }
  //   } catch (e) {
  //     _deviceId = 'unknown_device';
  //     _osType = 'unknown';
  //   }
  //   if (mounted) setState(() {});
  // }

  Future<void> _getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id; // ✅ Unique per app per device
        _osType = 'Android';
        print('📱 Android ID: $_deviceId');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor!; // ✅ Unique per vendor
        _osType = 'iOS';
        print('🍎 iOS ID (identifierForVendor): $_deviceId');
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        _deviceId = 'windows_${windowsInfo.computerName}';
        _osType = 'Windows';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        _deviceId = 'macos_${macInfo.computerName}';
        _osType = 'macOS';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        _deviceId = 'linux_${linuxInfo.machineId}';
        _osType = 'Linux';
      } else {
        // Fallback for Web or unknown platforms
        _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        _osType = 'Web';
      }
    } catch (e, stackTrace) {
      print("❌ Failed to get device info: $e\n$stackTrace");
      _deviceId = 'CTRG';
      _osType = 'Unknown';
    }

    // Update UI safely
    if (mounted) {
      setState(() {
        print("🔄 Device ID set: $_deviceId | OS: $_osType");
      });
    }
  }

  Future<void> _searchUserAndSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final String phone = _phoneController.text.trim();

    // ✅ PRINT THE PHONE NUMBER HERE
    print('📞 Phone Number (with +91): $phone');

    setState(() {
      _isLoading = true;
    });

    try {
      // 🔍 Step 1: Search if user exists
      final searchResponse = await http.post(
        Uri.parse('${Constants.baseUrl}/searchUserusingphoneNo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      print('this is ths  search response $searchResponse.body');

      if (searchResponse.statusCode == 200) {
        final userData = jsonDecode(searchResponse.body);
        print('🎯 User ID (_id): $userData');

        // final String? userId = userData['_id'];
        final String? userId = userData['user']?['_id'];
        // final String? phone = userData['user']?['phone'];
        final String? deviceId = userData['user']?['deviceid'];

        // final bool userExists = userData['name'] == true;

        print('🎯 User ID (_id): $userId');

        if (userId != null) {
          // ✅ User found → proceed to send OTP
          await _sendOtp(phone, userId);
        } else {
          // ❌ User doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No account found. Please register.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        }
      } else {
        // Handle API error
        final error = jsonDecode(searchResponse.body);
        final message = error['message'] ?? 'User not found.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $message')));
        if (debugMode) print('🔍 Search User Error: $message');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: Unable to reach server.')),
      );
      if (debugMode) print('🚨 Search User Exception: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendOtp(String phone, String userId) async {
    try {
      final String fullPhone = phone;

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}${Constants.resendOtpEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': fullPhone,
          'deviceId': _deviceId,
          'osType': _osType,
          'userId': userId, // optional, if backend needs it
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('OTP sent to +91$phone')));

        // ✅ Navigate to OTP screen with userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginWithOtpScreen(
              userId: userId,
              phone: phone,
              deviceId: _deviceId,
              osType: _osType,
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        final errorMsg = error['message'] ?? 'Failed to send OTP.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('OTP Error: $errorMsg')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP. Check connection.')),
      );
      if (debugMode) print('🚨 Send OTP Exception: $e');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "e.g. 9876543210",
                    prefixText: "+91 ",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  validator: (value) {
                    final phone = value?.trim();
                    if (phone == null || phone.isEmpty) {
                      return 'Phone is required';
                    }
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                      return 'Enter valid 10-digit number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _searchUserAndSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text("Send OTP", style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const bool debugMode = true;
}
