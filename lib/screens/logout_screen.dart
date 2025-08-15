// screens/logout_screen.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // Clears all data (or use remove('isLoggedIn') for selective)

    // Redirect to LoginScreen and **remove all routes** so user can't go back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account"), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "User Settings",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ListTile(
              leading: Icon(Icons.person, color: Colors.teal),
              title: Text("Profile"),
              onTap: () {
                // Future: Navigate to profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile feature coming soon!")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.teal),
              title: Text("Change Password"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Change password coming soon!")),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => _logout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Logout", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
