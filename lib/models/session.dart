// models/session.dart
class Session {
  final String id;
  final String title;
  final String speaker;
  final String time; // e.g., "9:00 AM - 10:00 AM"
  final String location;
  final String description;
  final DateTime date; // ✅ Add date field

  Session({
    required this.id,
    required this.title,
    required this.speaker,
    required this.time,
    required this.location,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'speaker': speaker,
      'time': time,
      'location': location,
      'description': description,
      'date': date.toIso8601String(), // Save as string
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      speaker: map['speaker'],
      time: map['time'],
      location: map['location'],
      description: map['description'],
      date: DateTime.parse(map['date']), // Reconstruct date
    );
  }
}
