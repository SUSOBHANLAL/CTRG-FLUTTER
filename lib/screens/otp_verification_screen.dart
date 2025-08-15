// // screens/otp_verification_screen.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';
// import 'bottom_navigation.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   final String userId;

//   OtpVerificationScreen({required this.userId});

//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final _otpController = TextEditingController();
//   bool _isLoading = false;
//   int _resendCooldown = 0;

//   // 🔁 Set to true to enable detailed console logs
//   static const bool debugMode = true;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }

//   void _startResendTimer() {
//     _resendCooldown = 30;
//     Future.doWhile(() async {
//       if (_resendCooldown > 0 && mounted) {
//         await Future.delayed(Duration(seconds: 1));
//         setState(() {
//           _resendCooldown--;
//         });
//         return true;
//       }
//       return false;
//     });
//   }

//   Future<void> _resendOtp() async {
//     if (_resendCooldown > 0) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final url = Uri.parse(
//         '${Constants.baseUrl}${Constants.resendOtpEndpoint}',
//       );
//       final body = {'userId': widget.userId};

//       if (debugMode) debugPrint('👉 Resend OTP Request: $url | Body: $body');

//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );

//       if (debugMode) {
//         debugPrint('📭 Resend OTP Response Status: ${response.statusCode}');
//         debugPrint('📄 Resend OTP Response Body: ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data['message'] ?? 'OTP resent successfully!'),
//           ),
//         );
//         _startResendTimer();
//       } else {
//         final error = jsonDecode(response.body);
//         final errorMsg = error['message'] ?? 'Failed to resend OTP.';
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $errorMsg')));

//         if (debugMode) debugPrint('❌ Resend OTP Failed: $errorMsg');
//       }
//     } catch (e, stackTrace) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to resend OTP. Please retry.')),
//       );

//       if (debugMode) {
//         debugPrint('🚨 Exception in _resendOtp: $e');
//         debugPrint('📋 Stack Trace: $stackTrace');
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _verifyOtp() async {
//     final otp = _otpController.text.trim();
//     if (otp.isEmpty || otp.length != 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid 4-digit OTP.')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final url = Uri.parse(
//         '${Constants.baseUrl}${Constants.verifyOtpUsingUserIdEndpoint}',
//       );
//       final body = {'userId': widget.userId, 'enteredOtp': otp};

//       if (debugMode) debugPrint('👉 Verify OTP Request: $url | Body: $body');

//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );

//       if (debugMode) {
//         debugPrint('📭 Verify OTP Response Status: ${response.statusCode}');
//         debugPrint('📄 Verify OTP Response Body: ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('userId', widget.userId);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data['message'] ?? 'Verification successful!'),
//           ),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => BottomNavigation()),
//         );
//       } else {
//         final error = jsonDecode(response.body);
//         final errorMsg = error['message'] ?? 'Invalid or expired OTP.';
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $errorMsg')));

//         if (debugMode) debugPrint('❌ OTP Verification Failed: $errorMsg');
//       }
//     } catch (e, stackTrace) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Network error. Please check your connection.')),
//       );

//       if (debugMode) {
//         debugPrint('🚨 Exception in _verifyOtp: $e');
//         debugPrint('📋 Stack Trace: $stackTrace');
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Verify OTP"), backgroundColor: Colors.teal),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Enter the 4-digit OTP sent to your phone",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 24),
//               TextField(
//                 controller: _otpController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 4,
//                 textAlign: TextAlign.center,
//                 decoration: InputDecoration(
//                   labelText: "OTP",
//                   hintText: "1234",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   counterText: "",
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _verifyOtp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(color: Colors.white),
//                       )
//                     : Text("Verify OTP", style: TextStyle(fontSize: 18)),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Didn't receive OTP? "),
//                   _resendCooldown > 0
//                       ? Text(
//                           "Resend in $_resendCooldown s",
//                           style: TextStyle(color: Colors.grey),
//                         )
//                       : TextButton(
//                           onPressed: _resendOtp,
//                           child: Text("Resend OTP"),
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//============================================================================================================

// screens/otp_verification_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'bottom_navigation.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String phone;
  final String deviceId;
  final String osType;

  const OtpVerificationScreen({
    super.key,
    required this.userId,
    required this.phone,
    required this.deviceId,
    required this.osType,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendCooldown = 0;

  // 🔁 Set to true to enable detailed console logs
  static const bool debugMode = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendCooldown = 30;
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
      final url = Uri.parse(
        '${Constants.baseUrl}${Constants.resendOtpEndpoint}',
      );
      final body = {'userId': widget.userId};

      if (debugMode) {
        debugPrint('👉 Resend OTP Request: $url | Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (debugMode) {
        debugPrint('📭 Resend OTP Response Status: ${response.statusCode}');
        debugPrint('📄 Resend OTP Response Body: ${response.body}');
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
        const SnackBar(content: Text('⚠️ Failed to resend OTP. Please retry.')),
      );
      if (debugMode) {
        debugPrint('🚨 Exception in _resendOtp: $e');
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
    if (otp.isEmpty || otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit OTP.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        '${Constants.baseUrl}${Constants.verifyOtpUsingUserIdEndpoint}',
      );
      final body = {'userId': widget.userId, 'enteredOtp': otp};

      if (debugMode) {
        debugPrint('👉 Verify OTP Request: $url | Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (debugMode) {
        debugPrint('📭 Verify OTP Response Status: ${response.statusCode}');
        debugPrint('📄 Verify OTP Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', widget.userId);
        await prefs.setString('phone', widget.phone);
        await prefs.setString('deviceId', widget.deviceId);
        await prefs.setString('osType', widget.osType);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? '🎉 Verification successful!'),
          ),
        );

        // ✅ Navigate to BottomNavigation with all required parameters
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
        final errorMsg = error['message'] ?? 'Invalid or expired OTP.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ $errorMsg')));
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📶 Network error. Please check your connection.'),
        ),
      );
      if (debugMode) {
        debugPrint('🚨 Exception in _verifyOtp: $e');
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
                'Enter the 4-digit OTP sent to your phone',
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
                    : const Text("Verify OTP", style: TextStyle(fontSize: 18)),
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
