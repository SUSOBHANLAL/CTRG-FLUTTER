// screens/agenda_screen.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/session.dart';
import 'package:my_flutter_app/utils/user_session.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<List<Session>> agendaFuture;

  @override
  void initState() {
    super.initState();
    agendaFuture = UserSession.loadAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Agenda"), backgroundColor: Colors.teal),
      body: FutureBuilder<List<Session>>(
        future: agendaFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final agenda = snapshot.data!;
            if (agenda.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Your agenda is empty",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Browse Sessions"),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: agenda.length,
              itemBuilder: (context, index) {
                final session = agenda[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      session.time.split(' ')[0], // "9:00"
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  title: Text(session.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("by ${session.speaker}"),
                      Text(session.location),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(session.title),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Time: ${session.time}"),
                            Text("Speaker: ${session.speaker}"),
                            Text("Location: ${session.location}"),
                            SizedBox(height: 10),
                            Text(session.description),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load agenda"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
