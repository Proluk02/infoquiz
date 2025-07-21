import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoquiz/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_colors.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final String level;
  final String userId;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.level,
    required this.userId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  List<String> correctQuestions = [];
  List<String> wrongQuestions = [];
  int currentIndex = 0;
  int? selectedIndex;
  int score = 0;
  int remainingTime = 30;
  Timer? timer;
  bool showAnswer = false;
  String explanation = '';
  bool isLoading = true;
  late ConfettiController _confettiController;

  double get progress => remainingTime / 30;
  String get quizId =>
      '${widget.categoryId}_${widget.subcategoryId}_${widget.level}';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    setState(() => isLoading = true);
    final query = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('subcategories')
        .doc(widget.subcategoryId)
        .collection('levels')
        .doc(widget.level)
        .collection('questions');

    try {
      final snapshot = await query.get();
      final fetched =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'question': data['question'],
              'options': List<String>.from(data['options'] ?? []),
              'answerIndex': data['answerIndex'] ?? 0,
              'explanation': data['explanation'] ?? '',
            };
          }).toList();
      fetched.shuffle();

      if (fetched.isEmpty) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aucune question disponible pour ce quiz."),
          ),
        );
        Navigator.pop(context);
        return;
      }

      setState(() {
        questions = fetched.take(6).toList();
        isLoading = false;
        currentIndex = 0;
        selectedIndex = null;
        score = 0;
        showAnswer = false;
        explanation = '';
        correctQuestions.clear();
        wrongQuestions.clear();
      });

      if (questions.isNotEmpty) startTimer();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur de chargement : $e")));
    }
  }

  void startTimer() {
    remainingTime = 30;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remainingTime == 0) {
        t.cancel();
        setState(() => showAnswer = true);
      } else {
        setState(() => remainingTime--);
      }
    });
  }

  void checkAnswer(int index) {
    if (showAnswer) return;
    final correct = questions[currentIndex]['answerIndex'];
    final questionText = questions[currentIndex]['question'];

    setState(() {
      selectedIndex = index;
      showAnswer = true;
      timer?.cancel();
      explanation = questions[currentIndex]['explanation'];

      if (index == correct) {
        score++;
        correctQuestions.add(questionText);
      } else {
        wrongQuestions.add(questionText);
      }
    });
  }

  Future<void> saveBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${quizId}_best';
    final best = prefs.getInt(key) ?? 0;
    if (score > best) await prefs.setInt(key, score);
  }

  Future<void> updateUserStats() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        transaction.set(userRef, {
          'totalScore': score,
          'quizzesPlayed': 1,
          'highestScore': score,
        });
        return;
      }

      final current = snapshot.data() ?? {};
      final int totalScore = (current['totalScore'] ?? 0) + score;
      final int quizzesPlayed = (current['quizzesPlayed'] ?? 0) + 1;
      final int highestScore = current['highestScore'] ?? 0;
      final int newHighest = score > highestScore ? score : highestScore;

      transaction.update(userRef, {
        'totalScore': totalScore,
        'quizzesPlayed': quizzesPlayed,
        'highestScore': newHighest,
      });
    });
  }

  Future<void> saveFirestoreScore() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId);
    final now = DateTime.now();
    final userDoc = await userRef.get();
    final username = userDoc.data()?['username'] ?? 'Anonyme';
    final quizTitle =
        "${widget.categoryId} - ${widget.subcategoryId} (${widget.level})";

    await userRef.collection('scores').add({
      'quizId': quizId,
      'score': score,
      'total': questions.length,
      'timestamp': now,
      'correctQuestions': correctQuestions,
      'wrongQuestions': wrongQuestions,
    });

    await FirebaseFirestore.instance
        .collection('leaderboard')
        .doc('${quizId}_${widget.userId}')
        .set({
          'userId': widget.userId,
          'username': username,
          'quizId': quizId,
          'score': score,
          'total': questions.length,
          'timestamp': now,
          'correctQuestions': correctQuestions,
          'wrongQuestions': wrongQuestions,
        });

    await updateUserStats();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => ResultScreen(
              score: score,
              total: questions.length,
              confettiController: _confettiController,
              onReplay:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => QuizScreen(
                            categoryId: widget.categoryId,
                            subcategoryId: widget.subcategoryId,
                            level: widget.level,
                            userId: widget.userId,
                          ),
                    ),
                  ),
              username: username,
              quizTitle: quizTitle,
            ),
      ),
    );
  }

  void nextQuestion() async {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        showAnswer = false;
        explanation = '';
      });
      startTimer();
    } else {
      await saveBestScore();
      await saveFirestoreScore();
      if (score >= (questions.length / 2)) _confettiController.play();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            "Aucune question n’a été trouvée.",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }

    final current = questions[currentIndex];
    final correct = current['answerIndex'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                color: AppColors.primary,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${currentIndex + 1}".padLeft(2, '0')),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      Text("$remainingTime"),
                    ],
                  ),
                  Text("${questions.length}".padLeft(2, '0')),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                current['question'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(current['options'].length, (index) {
                final isCorrect = index == correct;
                final isSelected = index == selectedIndex;
                final isWrong = isSelected && !isCorrect;

                return Card(
                  color:
                      showAnswer
                          ? (isCorrect
                              ? Colors.green.shade50
                              : isWrong
                              ? Colors.red.shade50
                              : Colors.white)
                          : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: RadioListTile<int>(
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: showAnswer ? null : (i) => checkAnswer(i!),
                    title: Text(current['options'][index]),
                    activeColor: AppColors.primary,
                  ),
                );
              }),
              if (showAnswer && explanation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    explanation,
                    style: GoogleFonts.poppins(fontStyle: FontStyle.italic),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: showAnswer ? nextQuestion : null,
                child: Text(
                  currentIndex < questions.length - 1 ? "Suivant" : "Terminer",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final ConfettiController confettiController;
  final VoidCallback onReplay;
  final String username;
  final String quizTitle;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.confettiController,
    required this.onReplay,
    required this.username,
    required this.quizTitle,
  });

  String getAppreciation() {
    double ratio = score / total;
    if (ratio == 1) return "🎉 Parfait ! Incroyable !";
    if (ratio >= 0.8) return "🔥 Excellent travail !";
    if (ratio >= 0.6) return "👍 Bien joué !";
    if (ratio >= 0.4) return "🚐 Tu peux faire mieux.";
    return "💪 Ne baisse pas les bras !";
  }

  void shareScore(BuildContext context) {
    final message =
        '''📢 $username a joué à "$quizTitle" sur InfoQuiz !\n\n📊 Score : $score / $total\n${getAppreciation()}\n\n📱 Télécharge l'app et viens me défier ! 🔥''';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
            Text(
              'Score : $score / $total',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              getAppreciation(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReplay,
              child: const Text("🔁 Rejouer ce quiz"),
            ),
            ElevatedButton.icon(
              onPressed: () => shareScore(context),
              icon: const Icon(Icons.share),
              label: const Text("📤 Partager mon score"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("🏠 Retour à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
