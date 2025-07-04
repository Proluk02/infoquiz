import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final String level;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.level,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int? selectedAnswer;
  bool showAnswer = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final query =
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .collection('subcategories')
            .doc(widget.subcategoryId)
            .collection('levels')
            .doc(widget.level)
            .collection('questions')
            .get();

    setState(() {
      questions = query.docs.map((doc) => doc.data()).toList();
    });
  }

  void nextQuestion() {
    setState(() {
      selectedAnswer = null;
      showAnswer = false;
      currentIndex++;
    });
  }

  void finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(score: score, total: questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF8E2DE2),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = questions[currentIndex];
    final correctIndex = current['answerIndex'];
    final total = questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF9C27B0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.arrow_back, color: Colors.white),
                          Icon(Icons.tune, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Center(
                            child: Text(
                              '${currentIndex + 1}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9C27B0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Question ${currentIndex + 1}/$total',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '05',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '07',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              current['question'],
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate((current['options'] as List).length, (
                        index,
                      ) {
                        final isCorrect = index == correctIndex;
                        final isSelected = selectedAnswer == index;

                        Icon? statusIcon;
                        Color borderColor = Colors.purple;
                        Color textColor = Colors.black;

                        if (showAnswer) {
                          if (isCorrect) {
                            statusIcon = const Icon(
                              Icons.check_circle,
                              color: Colors.purple,
                            );
                          } else if (isSelected && !isCorrect) {
                            statusIcon = const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            );
                            borderColor = Colors.red;
                            textColor = Colors.red;
                          } else {
                            statusIcon = const Icon(
                              Icons.radio_button_off,
                              color: Colors.grey,
                            );
                            borderColor = Colors.grey;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            if (showAnswer) return;
                            setState(() {
                              selectedAnswer = index;
                              showAnswer = true;
                              if (isCorrect) score++;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    current['options'][index],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                if (statusIcon != null) statusIcon,
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              showAnswer
                                  ? (currentIndex < questions.length - 1
                                      ? nextQuestion
                                      : finishQuiz)
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C27B0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            currentIndex < questions.length - 1
                                ? "Next"
                                : "Finish",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E2DE2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your Score",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "$score pt",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "$score Correct - ${total - score} Wrong",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Back to Home"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
