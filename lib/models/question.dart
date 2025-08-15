// models/question.dart
class Question {
  final String id;
  final String text;
  final String userId;
  final DateTime timestamp;
  final int upvotes;

  Question({
    required this.id,
    required this.text,
    required this.userId,
    required this.timestamp,
    required this.upvotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'upvotes': upvotes,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      userId: map['userId'],
      timestamp: DateTime.parse(map['timestamp']),
      upvotes: map['upvotes'],
    );
  }
}
