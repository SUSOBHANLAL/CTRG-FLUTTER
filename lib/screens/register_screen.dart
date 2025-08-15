// // screens/register_screen.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:device_info_plus/device_info_plus.dart';
// import '../utils/constants.dart';
// import 'otp_verification_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _dateOfBirthController = TextEditingController();

//   bool _isLoading = false;
//   String _selectedGender = 'male';
//   String _selectedUserRole = 'user';
//   String _deviceId = '';
//   String _osType = '';

//   @override
//   void initState() {
//     super.initState();
//     _getDeviceDetails();
//   }

//   Future<void> _getDeviceDetails() async {
//     final deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         final androidInfo = await deviceInfo.androidInfo;
//         _deviceId = 'android_${androidInfo.id}';
//         _osType = 'Android';
//       } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         _deviceId = 'ios_${iosInfo.identifierForVendor}';
//         _osType = 'iOS';
//       } else {
//         _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
//         _osType = 'Web';
//       }
//     } catch (e) {
//       _deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
//       _osType = 'Unknown';
//     }
//     if (mounted) setState(() {});
//   }

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final requestBody = {
//         'name': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'password': _passwordController.text.trim(),
//         'confirmPassword': _confirmPasswordController.text.trim(),
//         'address': _addressController.text.trim(),
//         'dateOfBirth': _dateOfBirthController.text.trim(),
//         'gender': _selectedGender,
//         'userRole': _selectedUserRole,
//         'deviceId': _deviceId,
//         'ostype': _osType,
//       };

//       requestBody.removeWhere((key, value) => value == null || value == '');

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}${Constants.registerWithOtpEndpoint}'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data['message'] ?? 'Registration successful!'),
//           ),
//         );

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 OtpVerificationScreen(phone: _phoneController.text.trim()),
//           ),
//         );
//       } else {
//         final error = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error['message'] ?? 'Registration failed.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Network error: Please try again.')),
//       );
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
//     _nameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _addressController.dispose();
//     _dateOfBirthController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register"), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: "Full Name",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty)
//                       return "Name is required";
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Phone Number",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return "Phone is required";
//                     if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//                       return "Enter valid 10-digit number";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.length < 6) {
//                       return "Password must be at least 6 characters";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   decoration: InputDecoration(
//                     labelText: "Confirm Password",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value != _passwordController.text) {
//                       return "Passwords do not match";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _addressController,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: "Address",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _dateOfBirthController,
//                   decoration: InputDecoration(
//                     labelText: "Date of Birth",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime(1990),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         _dateOfBirthController.text =
//                             "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                       });
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return "Date of Birth is required";
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Text("Gender", style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         items: ['male', 'female', 'other']
//                             .map(
//                               (g) => DropdownMenuItem(
//                                 value: g,
//                                 child: Text(g.toUpperCase()),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) =>
//                             setState(() => _selectedGender = value!),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Text("User Role", style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedUserRole,
//                         items: ['user', 'driver']
//                             .map(
//                               (r) => DropdownMenuItem(
//                                 value: r,
//                                 child: Text(r.toUpperCase()),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) =>
//                             setState(() => _selectedUserRole = value!),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),

//                 _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                         onPressed: _register,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           "Register",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                 SizedBox(height: 12),

//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Already have an account? Login"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//===========================================================================================
// // screens/register_screen.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:device_info_plus/device_info_plus.dart';
// import '../utils/constants.dart';
// import 'otp_verification_screen.dart';
// import 'dart:io' show Platform;

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _dateOfBirthController = TextEditingController();

//   bool _isLoading = false;
//   String _selectedGender = 'male';
//   String _selectedUserRole = 'user';
//   String _deviceId = '';
//   String _osType = '';

//   @override
//   void initState() {
//     super.initState();
//     _getDeviceDetails();
//   }

//   // Future<void> _getDeviceDetails() async {
//   //   final deviceInfo = DeviceInfoPlugin();
//   //   try {
//   //     if (Theme.of(context).platform == TargetPlatform.android) {
//   //       final androidInfo = await deviceInfo.androidInfo;
//   //       _deviceId = androidInfo.id;
//   //       _osType = 'Android';
//   //     }
//   //     //
//   //     // else if (Theme.of(context).platform == TargetPlatform.iOS) {
//   //     //   // final iosInfo = await deviceInfo.iosInfo;
//   //     //   // _deviceId = iosInfo.identifierForVendor;
//   //     //   _osType = 'iOS';
//   //     // }
//   //     else {
//   //       _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
//   //       _osType = 'Web';
//   //     }
//   //   } catch (e) {
//   //     _deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
//   //     _osType = 'Unknown';
//   //   }

//   //   if (mounted) setState(() {});
//   // }

//   Future<void> _getDeviceDetails() async {
//     final deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         _deviceId = androidInfo.id; // ✅ Unique per app per device
//         _osType = 'Android';
//         print('📱 Android ID: $_deviceId');
//       } else if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         _deviceId = iosInfo.identifierForVendor!; // ✅ Unique per vendor
//         _osType = 'iOS';
//         print('🍎 iOS ID (identifierForVendor): $_deviceId');
//       } else if (Platform.isWindows) {
//         final windowsInfo = await deviceInfo.windowsInfo;
//         _deviceId = 'windows_${windowsInfo.computerName}';
//         _osType = 'Windows';
//       } else if (Platform.isMacOS) {
//         final macInfo = await deviceInfo.macOsInfo;
//         _deviceId = 'macos_${macInfo.computerName}';
//         _osType = 'macOS';
//       } else if (Platform.isLinux) {
//         final linuxInfo = await deviceInfo.linuxInfo;
//         _deviceId = 'linux_${linuxInfo.machineId}';
//         _osType = 'Linux';
//       } else {
//         // Fallback for Web or unknown platforms
//         _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
//         _osType = 'Web';
//       }
//     } catch (e, stackTrace) {
//       print("❌ Failed to get device info: $e\n$stackTrace");
//       _deviceId = 'CTRG';
//       _osType = 'Unknown';
//     }

//     // Update UI safely
//     if (mounted) {
//       setState(() {
//         print("🔄 Device ID set: $_deviceId | OS: $_osType");
//       });
//     }
//   }

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final requestBody = {
//         'name': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'password': _passwordController.text.trim(),
//         'confirmPassword': _confirmPasswordController.text.trim(),
//         'address': _addressController.text.trim(),
//         'dateOfBirth': _dateOfBirthController.text.trim(),
//         'gender': _selectedGender,
//         'userRole': _selectedUserRole,
//         'deviceId': _deviceId,
//         'ostype': _osType,
//       };

//       requestBody.removeWhere((key, value) => value == null || value == '');

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}${Constants.registerWithOtpEndpoint}'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final String? userId = data['userId'] ?? data['data']?['userId'];

//         if (userId == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Registration successful, but no userId received.'),
//             ),
//           );
//           return;
//         }

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('OTP sent! Please verify.')));

//         // ✅ Navigate to OTP screen with userId
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OtpVerificationScreen(userId: userId),
//           ),
//         );
//       } else {
//         final error = jsonDecode(response.body);
//         String errorMsg = error['message'] ?? 'Registration failed.';
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $errorMsg')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Network error: ${e.toString().substring(0, 50)}...'),
//         ),
//       );
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
//     _nameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _addressController.dispose();
//     _dateOfBirthController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register"), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // [All your form fields: name, phone, password, etc.]
//                 // ... (same as before)
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: "Full Name",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty)
//                       return "Name is required";
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Phone Number",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return "Phone is required";
//                     if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//                       return "Enter valid 10-digit number";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.length < 6) {
//                       return "Password must be at least 6 characters";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   decoration: InputDecoration(
//                     labelText: "Confirm Password",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value != _passwordController.text) {
//                       return "Passwords do not match";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _addressController,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: "Address",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 TextFormField(
//                   controller: _dateOfBirthController,
//                   decoration: InputDecoration(
//                     labelText: "Date of Birth",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime(1990),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         _dateOfBirthController.text =
//                             "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                       });
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return "Date of Birth is required";
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Text("Gender", style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         items: ['male', 'female', 'other']
//                             .map(
//                               (g) => DropdownMenuItem(
//                                 value: g,
//                                 child: Text(g.toUpperCase()),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) =>
//                             setState(() => _selectedGender = value!),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Text("User Role", style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedUserRole,
//                         items: ['user', 'driver']
//                             .map(
//                               (r) => DropdownMenuItem(
//                                 value: r,
//                                 child: Text(r.toUpperCase()),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (value) =>
//                             setState(() => _selectedUserRole = value!),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),

//                 _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                         onPressed: _register,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           "Register",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                 SizedBox(height: 12),

//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Already have an account? Login"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//===========================================================================================================

// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import '../utils/constants.dart';
import 'otp_verification_screen.dart';
import 'dart:io' show Platform;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  bool _isLoading = false;
  String _selectedGender = 'male';
  String _selectedUserRole = 'user';
  String _deviceId = 'CTRG'; // Default fallback
  String _osType = 'Unknown'; // Default fallback

  @override
  void initState() {
    super.initState();
    _getDeviceDetails();
  }

  /// Fetches unique device ID and OS type
  Future<void> _getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id; // Unique to app per device
        _osType = 'Android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
        _osType = 'iOS';
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
        // Web or unknown
        _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        _osType = 'Web';
      }
    } catch (e, stackTrace) {
      print("❌ Failed to get device info: $e\n$stackTrace");
      _deviceId = 'CTRG_${DateTime.now().millisecondsSinceEpoch}';
      _osType = 'Unknown';
    }

    if (mounted) {
      setState(() {
        // Optional: log for debugging
        print("📱 Device: $_deviceId | OS: $_osType");
      });
    }
  }

  /// Handles user registration
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String phone = _phoneController.text.trim();

      final requestBody = {
        'name': _nameController.text.trim(),
        'phone': phone,
        'password': _passwordController.text.trim(),
        'confirmPassword': _confirmPasswordController.text.trim(),
        'address': _addressController.text.trim(),
        'dateOfBirth': _dateOfBirthController.text.trim(),
        'gender': _selectedGender,
        'userRole': _selectedUserRole,
        'deviceId': _deviceId,
        'osType': _osType, // ✅ Fixed: was 'ostype' (lowercase and wrong key)
      };

      // Remove empty or null values
      requestBody.removeWhere((key, value) => value == '');

      final url = Uri.parse(
        '${Constants.baseUrl}${Constants.registerWithOtpEndpoint}',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (debugMode) {
        print('📤 Register Request: $url');
        print('📦 Body: $requestBody');
        print('📥 Status: ${response.statusCode}');
        print('📄 Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final String? userId = data['userId'] ?? data['data']?['userId'];

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Registered, but no userId received.')),
          );
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('📩 OTP sent! Please verify.')));

        // ✅ Navigate to OTP screen with ALL required parameters
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              userId: userId,
              phone: phone,
              deviceId: _deviceId,
              osType: _osType,
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        String errorMsg =
            error['message'] ?? 'Registration failed. Please try again.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ $errorMsg')));
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Network error. Please check connection.')),
      );
      if (debugMode) {
        print('🚨 Exception in _register: $e');
        print('📋 Stack Trace: $stackTrace');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  static const bool debugMode = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone is required";
                    }
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                      return "Enter a valid 10-digit Indian number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),

                // Date of Birth
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1990),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _dateOfBirthController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Date of Birth is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Gender
                Row(
                  children: [
                    const Text("Gender", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        items: ['male', 'female', 'other']
                            .map(
                              (g) => DropdownMenuItem(
                                value: g,
                                child: Text(g.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedGender = value!),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // User Role
                Row(
                  children: [
                    const Text("User Role", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedUserRole,
                        items: ['user', 'driver']
                            .map(
                              (r) => DropdownMenuItem(
                                value: r,
                                child: Text(r.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedUserRole = value!),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      )
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                const SizedBox(height: 12),

                // Login Link
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
