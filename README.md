# my_flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

tpmdc_app/
├── android/
├── build/
├── ios/
├── lib/
│ ├── main.dart
│ ├── services/
│ │ └── api_service.dart # For HTTP calls to Node.js backend
│ ├── models/
│ │ ├── home_data.dart # Model class for Home Screen data
│ │ ├── schedule_data.dart # Model class for Schedule Data
│ │ ├── venue_data.dart # Model class for Venue Info
│ │ └── contact_data.dart # Model class for Contact Info
│ ├── screens/
│ │ ├── home_screen.dart
│ │ ├── map_screen.dart
│ │ ├── schedule_screen.dart
│ │ ├── venue_screen.dart
│ │ └── contact_us_screen.dart
│ ├── widgets/
│ │ └── loading_indicator.dart # Reusable loader widget
│ └── utils/
│ └── constants.dart # Constants like API URLs
├── test/
├── pubspec.yaml
├── assets/ # Optional: images from backend or local
└── README.md # App documentation

screens/
├── auth/
│ ├── login_screen.dart
│ ├── register_screen.dart
│ └── otp_verification_screen.dart
├── event/
│ ├── sessions_screen.dart
│ ├── live_engagement_screen.dart
│ └── venue_screen.dart
├── profile/
│ ├── documents_screen.dart
│ └── assessment_screen.dart
├── navigation/
│ └── bottom_navigation.dart
└── others/
└── notifications_screen.dart
