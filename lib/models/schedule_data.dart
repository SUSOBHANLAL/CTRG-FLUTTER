class Schedule {
  final String id;
  final String event;
  final Map<String, String> timing;
  final String venue;
  final String date;
  final String month;
  final String year;

  Schedule({
    required this.id,
    required this.event, // <-- required
    required this.timing,
    required this.venue,
    required this.date,
    required this.month,
    required this.year,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['_id'],
      event: json['event'] ?? 'Event', // <-- from JSON
      timing: {
        'from': json['timing']['from'] ?? '',
        'to': json['timing']['to'] ?? '',
      },
      venue: json['venue'] ?? '',
      date: json['date'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
    );
  }
}
