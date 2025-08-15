//------------------------------------------------------------------------------------------------

// main.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'utils/user_session.dart'; // ← Add this file (we’ll create it below)
// import 'screens/login_screen.dart';
// import 'screens/bottom_navigation.dart'; // Renamed for clarity

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//   runApp(MyApp(isLoggedIn: isLoggedIn));
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;

//   MyApp({required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TPMDC App',
//       theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Calibri'),
//       home: isLoggedIn ? BottomNavigation() : LoginScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// main.dart
//=================================================================2nd =====================================

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'utils/user_session.dart';
// import 'screens/login_screen.dart';
// import 'screens/bottom_navigation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize UserSession
//   await UserSession.init();

//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isCheckingSession = true;
//   bool _isLoggedIn = false;

//   // Variables to hold session data
//   String? _userId;
//   String? _phone;
//   String? _deviceId;
//   String? _osType;

//   @override
//   void initState() {
//     super.initState();
//     _loadSessionData();
//   }

//   Future<void> _loadSessionData() async {
//     final isLoggedIn = UserSession.isLoggedIn();
//     final userId = UserSession.getUserId();
//     final phone = UserSession.getPhone();
//     final deviceId = UserSession.getDeviceId();
//     final osType = UserSession.getOsType();

//     print("this si logged in $isLoggedIn");

//     // Only proceed if logged in AND all required data exists
//     bool isDataValid =
//         isLoggedIn &&
//         userId != null &&
//         phone != null &&
//         deviceId != null &&
//         osType != null;

//     setState(() {
//       _isLoggedIn = isDataValid;
//       _userId = userId;
//       _phone = phone;
//       _deviceId = deviceId;
//       _osType = osType;
//       _isCheckingSession = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isCheckingSession) {
//       return MaterialApp(
//         home: Scaffold(
//           body: Center(child: CircularProgressIndicator(color: Colors.teal)),
//         ),
//         debugShowCheckedModeBanner: false,
//       );
//     }

//     // ✅ Now safely pass data only if valid
//     return MaterialApp(
//       title: 'TPMDC App',
//       theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Calibri'),
//       home: _isLoggedIn && _userId != null
//           ? BottomNavigation(
//               userId: _userId!,
//               phone: _phone!,
//               deviceId: _deviceId!,
//               osType: _osType!,
//             )
//           : LoginScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

//========================================================================================================

// // main.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'utils/user_session.dart';
// import 'screens/login_screen.dart';
// import 'screens/bottom_navigation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize session storage
//   await UserSession.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isCheckingSession = true;
//   bool _isLoggedIn = false;

//   // Session data
//   String? _userId;
//   String? _phone;
//   String? _deviceId;
//   String? _osType;

//   @override
//   void initState() {
//     super.initState();
//     _loadSessionData();
//   }

//   Future<void> _loadSessionData() async {
//     final isLoggedIn = UserSession.isLoggedIn();
//     final userId = UserSession.getUserId();
//     final phone = UserSession.getPhone();
//     final deviceId = UserSession.getDeviceId();
//     final osType = UserSession.getOsType();

//     // 🔍 Debug: Check what's stored
//     print("🔐 Session Debug:");
//     print("  isLoggedIn: $isLoggedIn");
//     print("  userId: $userId");
//     print("  phone: $phone");
//     print("  deviceId: $deviceId");
//     print("  osType: $osType");

//     // ✅ Only consider logged in if ALL required data exists
//     bool isDataValid =
//         isLoggedIn &&
//         userId != null &&
//         phone != null &&
//         deviceId != null &&
//         osType != null;

//     setState(() {
//       _isLoggedIn = isDataValid;
//       _userId = userId;
//       _phone = phone;
//       _deviceId = deviceId;
//       _osType = osType;
//       _isCheckingSession = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isCheckingSession) {
//       return MaterialApp(
//         home: Scaffold(
//           body: Center(child: CircularProgressIndicator(color: Colors.teal)),
//         ),
//         debugShowCheckedModeBanner: false,
//       );
//     }

//     // ✅ Navigate to home if session is valid
//     return MaterialApp(
//       title: 'TPMDC App',
//       theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Calibri'),
//       home: _isLoggedIn
//           ? BottomNavigation(
//               userId: _userId!,
//               phone: _phone!,
//               deviceId: _deviceId!,
//               osType: _osType!,
//             )
//           : LoginScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

//==========================================================================================

// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/user_session.dart';
import 'screens/login_screen.dart';
import 'screens/bottom_navigation.dart';

// 🔽 Add these imports
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

// ✅ Move getDeviceDetails() here (or keep in UserSession)
Future<Map<String, String>> getDeviceDetails() async {
  final deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return {'deviceId': android.id, 'osType': 'android'};
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return {
        'deviceId':
            ios.identifierForVendor ??
            'ios_unknown_${DateTime.now().millisecondsSinceEpoch}',
        'osType': 'ios',
      };
    } else {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return {'deviceId': 'web_$timestamp', 'osType': 'web'};
    }
  } catch (e) {
    print("❌ Failed to get device info: $e");
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return {'deviceId': 'unknown_$timestamp', 'osType': 'unknown'};
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize session storage
  await UserSession.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCheckingSession = true;
  bool _isLoggedIn = false;

  // Session data
  String? _userId;
  String? _phone;
  String? _deviceId;
  String? _osType;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final isLoggedIn = UserSession.isLoggedIn();
    final userId = UserSession.getUserId();
    final phone = UserSession.getPhone();
    var deviceId = UserSession.getDeviceId();
    var osType = UserSession.getOsType();

    // 🔍 Debug: Initial state
    print("🔐 Session Debug (initial):");
    print("  isLoggedIn: $isLoggedIn");
    print("  userId: $userId");
    print("  phone: $phone");
    print("  deviceId: $deviceId");
    print("  osType: $osType");

    // ✅ If device info is missing, fetch it
    if (deviceId == null || osType == null) {
      print("📱 Device info missing, fetching...");
      final deviceInfo = await getDeviceDetails();
      deviceId = deviceInfo['deviceId']!;
      osType = deviceInfo['osType']!;

      // ✅ Save back to SharedPreferences for next launch
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('isLoggedIn') &&
          prefs.getBool('isLoggedIn') == true) {
        await prefs.setString('deviceId', deviceId);
        await prefs.setString('osType', osType);
        print("💾 Device info saved: $deviceId | $osType");
      }
    }

    // ✅ Only consider logged in if ALL required data exists
    bool isDataValid = isLoggedIn && userId != null && phone != null;

    setState(() {
      _isLoggedIn = isDataValid;
      _userId = userId;
      _phone = phone;
      _deviceId = deviceId;
      _osType = osType;
      _isCheckingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.teal)),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // ✅ Navigate to home if session is valid
    return MaterialApp(
      title: 'TPMDC App',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Calibri'),
      home: _isLoggedIn
          ? BottomNavigation(
              userId: _userId!,
              phone: _phone!,
              deviceId: _deviceId!,
              osType: _osType!,
            )
          : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
