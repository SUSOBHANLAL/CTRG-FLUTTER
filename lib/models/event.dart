class Event {
  final String id;
  final String scheduleId;
  final String eventName;
  final Map<String, dynamic> eventDetails;
  final String time; // e.g., "10:00 AM - 12:00 PM"
  final String venue; // e.g., "Main Hall"

  Event({
    required this.id,
    required this.scheduleId,
    required this.eventName,
    required this.eventDetails,
    required this.time,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      scheduleId: json['scheduleId'],
      eventName: json['event'],
      eventDetails: json['eventDetails'] ?? {},
      time: json['time'] ?? 'N/A',
      venue: json['venue'] ?? 'N/A',
    );
  }
}

// class Event {
//   final String id;
//   final String scheduleId;
//   final String eventName;
//   final Map<String, dynamic> eventDetails;
//   final String time; // e.g., "10:00 AM - 12:00 PM"
//   final String venue; // e.g., "Main Hall"

//   Event({
//     required this.id,
//     required this.scheduleId,
//     required this.eventName,
//     required this.eventDetails,
//     required this.time,
//     required this.venue,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     final timing =
//         json['eventDetails']['timing'] as Map<String, dynamic>? ?? {};
//     final from = timing['from'] ?? '';
//     final to = timing['to'] ?? '';

//     return Event(
//       id: json['_id'],
//       scheduleId: json['scheduleId'],
//       eventName: json['event'],
//       eventDetails: json['eventDetails'] ?? {},
//       time: '$from - $to',
//       venue: json['eventDetails']['venue'] ?? 'N/A',
//     );
//   }
// }
