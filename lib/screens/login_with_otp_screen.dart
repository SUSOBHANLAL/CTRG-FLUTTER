// screens/login_with_otp_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'bottom_navigation.dart';

// 🔁 Renamed class
class LoginWithOtpScreen extends StatefulWidget {
  final String userId;
  final String phone;
  final String deviceId;
  final String osType;

  const LoginWithOtpScreen({
    super.key,
    required this.userId,
    required this.phone,
    required this.deviceId,
    required this.osType,
  });

  @override
  _LoginWithOtpScreenState createState() => _LoginWithOtpScreenState();
}

class _LoginWithOtpScreenState extends State<LoginWithOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendCooldown = 0;

  static const bool debugMode = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendCooldown = 300;
    Future.doWhile(() async {
      if (_resendCooldown > 0 && mounted) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _resendCooldown--;
        });
        return true;
      }
      return false;
    });
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0 || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String fullPhone = '+91${widget.phone}';
      final url = Uri.parse('${Constants.baseUrl}/resendOtpForlogin');
      final body = {
        'phone': fullPhone,
        // 'deviceId': widget.deviceId,
        // 'osType': widget.osType,
      };

      if (debugMode) {
        debugPrint('🔄 Resending OTP to: $fullPhone');
        debugPrint('👉 Resend Request: $url | Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (debugMode) {
        debugPrint('📭 Resend OTP Status: ${response.statusCode}');
        debugPrint('📄 Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'] ?? 'OTP resent successfully!';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('✅ $message')));
        _startResendTimer();
      } else {
        final error = jsonDecode(response.body);
        String errorMsg = error['message'] ?? 'Failed to resend OTP.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ $errorMsg')));
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Failed to resend OTP. Check connection.'),
        ),
      );
      if (debugMode) {
        debugPrint('🚨 Exception (Resend): $e');
        debugPrint('📋 Stack Trace: $stackTrace');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit OTP.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String fullPhone = widget.phone;
      final url = Uri.parse('${Constants.baseUrl}/loginWithOtp');
      final body = {
        'phone': fullPhone,
        'otp': otp,
        'deviceId': widget.deviceId,
        'osType': widget.osType,
      };
      print("This is the  the body  while register$body");

      if (debugMode) {
        debugPrint('✅ Verifying OTP for: $fullPhone');
        debugPrint('👉 Verify Request: $url | Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (debugMode) {
        debugPrint('📭 Verification Status: ${response.statusCode}');
        debugPrint('📄 Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', widget.userId);
        await prefs.setString('phone', fullPhone);

        if (data.containsKey('token')) {
          await prefs.setString('authToken', data['token']);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 Logged in successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              userId: widget.userId,
              phone: widget.phone,
              deviceId: widget.deviceId,
              osType: widget.osType,
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        String errorMsg = error['message'] ?? 'Invalid or expired OTP.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ $errorMsg')));
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📶 Network error. Please try again.')),
      );
      if (debugMode) {
        debugPrint('🚨 Exception (Verify): $e');
        debugPrint('📋 Stack Trace: $stackTrace');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter the 4-digit OTP sent to +91 ${widget.phone}',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  hintText: "1234",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  counterText: "",
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        "Verify & Login",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive OTP? "),
                  _resendCooldown > 0
                      ? Text(
                          "Resend in $_resendCooldown s",
                          style: const TextStyle(color: Colors.red),
                        )
                      : TextButton(
                          onPressed: _resendOtp,
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
