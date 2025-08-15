// //========================================================================================================================

// // lib/screens/map_screen.dart
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   // Fixed destination
//   static const double destinationLat = 26.191161037872096;
//   static const double destinationLng = 91.6927108996099;
//   static const String destinationName = "Destination";

//   // Launch Google Maps Navigation
//   Future<void> _navigateToDestination(BuildContext context) async {
//     final uri = Uri.https(
//       'www.google.com', // Use 'www.google.com' for reliable routing
//       '/maps/dir/',
//       {
//         'api': '1',
//         'travelmode': 'driving',
//         'origin': 'Current+Location',
//         'destination': '$destinationLat,$destinationLng',
//         'dest_name': destinationName,
//       },
//     );

//     // Try to launch in Google Maps app
//     final String googleMapsUrl =
//         'https://www.google.com/maps/dir/?api=1&travelmode=driving&origin=Current+Location&destination=$destinationLat,$destinationLng';

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       // Fallback: Open in browser
//       final browserUri = Uri.parse(googleMapsUrl);
//       if (await canLaunchUrl(browserUri)) {
//         await launchUrl(browserUri);
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Could not open Google Maps")));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigate to Destination'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.location_on, size: 60, color: Colors.red),
//             SizedBox(height: 16),
//             Text(
//               'Tap below to start navigation',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () => _navigateToDestination(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: Icon(Icons.directions_car),
//               label: Text("Get Directions", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//================================================================================================================

// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Fixed destination for navigation
  static const double destinationLat = 26.191161037872096;
  static const double destinationLng = 91.6927108996099;
  static const String destinationName = "Event Venue";

  // Launch Google Maps Navigation
  Future<void> _navigateToDestination(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'travelmode': 'driving',
      'origin': 'Current+Location',
      'destination': '$destinationLat,$destinationLng',
      'dest_name': destinationName,
    });

    final url = uri.toString();

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: Open in browser
      final browserUri = Uri.parse(url);
      if (await canLaunchUrl(browserUri)) {
        await launchUrl(browserUri);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not open Google Maps")));
      }
    }
  }

  // Share current location as a Google Maps link
  Future<void> _shareCurrentLocation(BuildContext context) async {
    // Google Maps link for "Current Location"
    final String shareLink =
        'https://www.google.com/maps/search/?api=1&query=Current+Location';

    final String message =
        'Here is my current location:\n$shareLink\n\nI’m on my way!';

    try {
      await Share.share(message);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to share location: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigate & Share Location'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 60, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Choose an action',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _navigateToDestination(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.directions_car),
              label: Text("Get Directions", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _shareCurrentLocation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.share),
              label: Text("Share My Location", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
