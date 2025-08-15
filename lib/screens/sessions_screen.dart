// screens/sessions_screen.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/session.dart';
import 'package:my_flutter_app/utils/user_session.dart';
import 'package:my_flutter_app/screens/agenda_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<Session> allSessions = [];
  Set<String> agendaSessionIds = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _loadAgenda();
  }

  void _loadSessions() {
    allSessions = [
      Session(
        id: "1",
        title: "Opening Keynote: Future of Banking",
        speaker: "Dr. Ravi Sharma",
        time: "9:00 AM - 10:00 AM",
        location: "Main Hall",
        description:
            "Explore the future trends in digital banking and financial inclusion.",
        date: DateTime(2025, 8, 1),
      ),
      Session(
        id: "2",
        title: "Resume Building Workshop",
        speaker: "Priya Mehta",
        time: "10:30 AM - 12:00 PM",
        location: "Workshop Room A",
        description: "Learn how to craft a winning resume for banking roles.",
        date: DateTime(2025, 8, 1),
      ),
      Session(
        id: "3",
        title: "Interview Skills Masterclass",
        speaker: "Amit Patel",
        time: "1:00 PM - 2:30 PM",
        location: "Workshop Room B",
        description: "Ace your next job interview with proven techniques.",
        date: DateTime(2025, 8, 2),
      ),
      Session(
        id: "4",
        title: "Networking & Career Fair",
        speaker: "HR Panel",
        time: "3:00 PM - 5:00 PM",
        location: "Exhibition Hall",
        description:
            "Meet recruiters from top banks and explore job opportunities.",
        date: DateTime(2025, 8, 2),
      ),
    ];
  }

  Map<DateTime, List<Session>> _groupSessionsByDate(List<Session> sessions) {
    final Map<DateTime, List<Session>> grouped = {};

    for (var session in sessions) {
      // Normalize date (ignore time)
      final date = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(session);
    }

    // Sort dates (oldest first)
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  void _loadAgenda() async {
    final agenda = await UserSession.loadAgenda();
    setState(() {
      agendaSessionIds = agenda.map((s) => s.id).toSet();
    });
  }

  void _toggleAgenda(Session session) async {
    setState(() {
      if (agendaSessionIds.contains(session.id)) {
        agendaSessionIds.remove(session.id);
      } else {
        agendaSessionIds.add(session.id);
      }
    });

    // Save updated agenda
    final updatedAgenda = allSessions
        .where((s) => agendaSessionIds.contains(s.id))
        .toList();
    await UserSession.saveAgenda(updatedAgenda);
  }

  @override
  Widget build(BuildContext context) {
    // Group sessions by date
    final groupedSessions = _groupSessionsByDate(allSessions);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sessions"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen()),
              );
            },
            tooltip: "My Agenda",
          ),
        ],
      ),
      body: groupedSessions.isEmpty
          ? Center(child: Text("No sessions available"))
          : ListView.builder(
              itemCount: groupedSessions.length,
              itemBuilder: (context, dateIndex) {
                final dateEntry = groupedSessions.entries.elementAt(dateIndex);
                final date = dateEntry.key;
                final sessions = dateEntry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.teal,
                      child: Text(
                        _formatDate(date),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Sessions for this date
                    ...sessions.map((session) {
                      final isInAgenda = agendaSessionIds.contains(session.id);
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.event,
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                                  Text(
                                    session.time,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                session.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "by ${session.speaker}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "📍 ${session.location}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                session.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () => _toggleAgenda(session),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInAgenda
                                        ? Colors.red
                                        : Colors.teal,
                                  ),
                                  icon: Icon(
                                    isInAgenda
                                        ? Icons.bookmark_remove
                                        : Icons.bookmark_add,
                                    size: 16,
                                  ),
                                  label: Text(
                                    isInAgenda ? "Remove" : "Add to Agenda",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }

  // Format date as "August 1, 2025"
  String _formatDate(DateTime date) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    // Add suffix to day: 1st, 2nd, 3rd, 4th, etc.
    String suffix = 'th';
    if (day % 10 == 1 && day != 11) {
      suffix = 'st';
    } else if (day % 10 == 2 && day != 12)
      suffix = 'nd';
    else if (day % 10 == 3 && day != 13)
      suffix = 'rd';

    return '$month $day$suffix, $year';
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Sessions"),
  //       backgroundColor: Colors.teal,
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.calendar_today),
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => AgendaScreen()),
  //             );
  //           },
  //           tooltip: "My Agenda",
  //         ),
  //       ],
  //     ),
  //     body: ListView.builder(
  //       itemCount: allSessions.length,
  //       itemBuilder: (context, index) {
  //         final session = allSessions[index];
  //         final isInAgenda = agendaSessionIds.contains(session.id);

  //         return Card(
  //           margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           child: Padding(
  //             padding: EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Icon(Icons.event, color: Colors.teal, size: 20),
  //                     Text(
  //                       session.time,
  //                       style: TextStyle(fontSize: 12, color: Colors.grey),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   session.title,
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //                 ),
  //                 SizedBox(height: 4),
  //                 Text(
  //                   "by ${session.speaker}",
  //                   style: TextStyle(fontSize: 14, color: Colors.blueGrey),
  //                 ),
  //                 SizedBox(height: 4),
  //                 Text(
  //                   "📍 ${session.location}",
  //                   style: TextStyle(fontSize: 13, color: Colors.grey),
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   session.description,
  //                   style: TextStyle(fontSize: 13, color: Colors.grey[700]),
  //                 ),
  //                 SizedBox(height: 12),
  //                 Align(
  //                   alignment: Alignment.centerRight,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () => _toggleAgenda(session),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: isInAgenda ? Colors.red : Colors.teal,
  //                     ),
  //                     icon: Icon(
  //                       isInAgenda ? Icons.bookmark_remove : Icons.bookmark_add,
  //                       size: 16,
  //                     ),
  //                     label: Text(
  //                       isInAgenda ? "Remove" : "Add to Agenda",
  //                       style: TextStyle(fontSize: 12),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
