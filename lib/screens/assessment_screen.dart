// screens/assessment_screen.dart
import 'package:flutter/material.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assessment"), backgroundColor: Colors.teal),
      body: Center(
        child: Text("Welcome to Assessment", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
