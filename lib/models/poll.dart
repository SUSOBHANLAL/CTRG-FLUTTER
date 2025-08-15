// models/poll.dart
class Poll {
  final String id;
  final String question;
  final List<String> options;
  final List<int> votes; // index-based votes
  final DateTime startTime;
  final DateTime endTime;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
    required this.startTime,
    required this.endTime,
  });

  bool isActive(DateTime now) {
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'votes': votes,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['id'],
      question: map['question'],
      options: List<String>.from(map['options']),
      votes: List<int>.from(map['votes']),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }
}
