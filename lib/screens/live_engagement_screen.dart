// screens/live_engagement_screen.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/poll.dart';
import 'package:my_flutter_app/models/question.dart';
import 'package:my_flutter_app/utils/user_session.dart';

class LiveEngagementScreen extends StatefulWidget {
  const LiveEngagementScreen({super.key});

  @override
  _LiveEngagementScreenState createState() => _LiveEngagementScreenState();
}

class _LiveEngagementScreenState extends State<LiveEngagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulated data
  final List<Poll> polls = [
    Poll(
      id: "1",
      question: "What is your biggest challenge in job interviews?",
      options: [
        "Lack of experience",
        "Nervousness",
        "Answering technical questions",
        "Salary negotiation",
      ],
      votes: [0, 0, 0, 0],
      startTime: DateTime.now().subtract(Duration(minutes: 5)),
      endTime: DateTime.now().add(Duration(hours: 1)),
    ),
  ];

  final List<Question> questions = [
    Question(
      id: "1",
      text: "How can I stand out with no prior banking experience?",
      userId: "user123",
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      upvotes: 24,
    ),
    Question(
      id: "2",
      text: "Is an MBA necessary for a career in investment banking?",
      userId: "user456",
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      upvotes: 18,
    ),
  ];

  final _questionController = TextEditingController();
  String _draft = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDraft();
  }

  void _loadDraft() async {
    final draft = await UserSession.loadQuestionDraft();
    if (draft != null) {
      setState(() {
        _draft = draft;
        _questionController.text = draft;
      });
    }
  }

  void _submitQuestion() async {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;

    // In real app: send to server
    setState(() {
      questions.insert(
        0,
        Question(
          id: "q${DateTime.now().millisecondsSinceEpoch}",
          text: text,
          userId: "current_user",
          timestamp: DateTime.now(),
          upvotes: 0,
        ),
      );
      _questionController.clear();
      _draft = '';
    });

    await UserSession.saveQuestionDraft('');
  }

  void _voteOnPoll(Poll poll, int optionIndex) async {
    final hasVoted = await UserSession.hasVoted(poll.id);
    if (hasVoted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You've already voted in this poll")),
      );
      return;
    }

    setState(() {
      poll.votes[optionIndex]++;
    });

    await UserSession.recordPollVote(poll.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Thank you for voting!")));
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Engagement"),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Q&A"),
            Tab(text: "Polls"),
            Tab(text: "Survey"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // === Q&A TAB ===
          _buildQaTab(),

          // === POLLS TAB ===
          _buildPollsTab(now),

          // === SURVEY TAB ===
          _buildSurveyTab(),
        ],
      ),
    );
  }

  Widget _buildQaTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: "Ask a question...",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _submitQuestion,
                    ),
                  ),
                  onSubmitted: (_) => _submitQuestion(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              return ListTile(
                title: Text(q.text),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${q.upvotes} upvotes • ${_formatTime(q.timestamp)}"),
                    SizedBox(height: 4),
                    Text(
                      "Asked by attendee",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_upward, size: 16),
                  onPressed: () {
                    setState(() {
                      questions[index] = Question(
                        id: q.id,
                        text: q.text,
                        userId: q.userId,
                        timestamp: q.timestamp,
                        upvotes: q.upvotes + 1,
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPollsTab(DateTime now) {
    return ListView.builder(
      itemCount: polls.length,
      itemBuilder: (context, index) {
        final poll = polls[index];
        final isActive = poll.isActive(now);
        final hasVoted = UserSession.hasVoted(poll.id).then((v) => v);

        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poll.question,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                ...poll.options.asMap().entries.map((entry) {
                  final i = entry.key;
                  final option = entry.value;
                  final percent = poll.votes.reduce((a, b) => a + b) == 0
                      ? 0
                      : (poll.votes[i] / poll.votes.reduce((a, b) => a + b)) *
                            100;

                  return Column(
                    children: [
                      if (isActive)
                        ListTile(
                          title: Text(option),
                          onTap: () => _voteOnPoll(poll, i),
                        )
                      else
                        Text(option),
                      LinearProgressIndicator(
                        value: percent / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${poll.votes[i]} votes (${percent.toStringAsFixed(0)}%)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 8),
                Text(
                  isActive ? "Voting active" : "Voting closed",
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurveyTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Session Feedback Survey",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildSurveyQuestion("How would you rate this session?"),
          _buildSurveyQuestion(
            "Was the content relevant to your career goals?",
          ),
          _buildSurveyQuestion("How likely are you to recommend this event?"),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Thank you for your feedback!")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text("Submit Survey"),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyQuestion(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: TextStyle(fontSize: 14)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) => Text("${i + 1}")),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
