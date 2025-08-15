// lib/screens/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final details = event.eventDetails;
    return Scaffold(
      appBar: AppBar(title: Text(event.eventName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Event Name: ${event.eventName}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Guest: ${details['guest'] ?? 'N/A'}"),
                SizedBox(height: 10),
                Text("Speaker: ${details['speaker'] ?? 'N/A'}"),
                SizedBox(height: 10),
                Text("Qualification: ${details['qualification'] ?? 'N/A'}"),
                SizedBox(height: 10),
                Text("Topic: ${details['topic'] ?? 'N/A'}"),
                SizedBox(height: 10),
                Text("Organization: ${details['organization'] ?? 'N/A'}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
