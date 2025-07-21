// 🎯 LeaderboardScreen pro et complet avec filtres, partage, médailles & animations

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infoquiz/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String? selectedQuiz;
  List<String> quizList = [];
  TimeFilter _filter = TimeFilter.week;

  @override
  void initState() {
    super.initState();
    _fetchQuizList();
  }

  Future<void> _fetchQuizList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('leaderboard').get();
    final quizzes =
        snapshot.docs
            .map((doc) => doc['quizId'].toString().toUpperCase())
            .toSet()
            .toList();
    setState(() {
      quizList = quizzes;
      selectedQuiz = quizzes.isNotEmpty ? quizzes.first : null;
    });
  }

  DateTime getFilterStartDate(TimeFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case TimeFilter.today:
        return DateTime(now.year, now.month, now.day);
      case TimeFilter.week:
        return now.subtract(const Duration(days: 7));
      case TimeFilter.month:
        return DateTime(now.year, now.month);
    }
  }

  Widget _buildRankMedal(int rank) {
    const double iconSize = 30;
    switch (rank) {
      case 0:
        return _medal(Icons.emoji_events, Colors.amber, iconSize);
      case 1:
        return _medal(Icons.emoji_events, Colors.grey, iconSize - 2);
      case 2:
        return _medal(Icons.emoji_events, Colors.brown, iconSize - 4);
      default:
        return CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 18,
          child: Text(
            '${rank + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget _medal(IconData icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color.withOpacity(0.6), color]),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }

  void _shareRank(String username, int rank, String quizId) {
    final msg =
        '🏆 $username est classé n°${rank + 1} sur le quiz "$quizId" dans InfoQuiz !\nViens me défier !';
    Share.share(msg);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final filterDate = getFilterStartDate(_filter);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('🏆 Classement'),
        actions: [
          DropdownButton<TimeFilter>(
            value: _filter,
            dropdownColor: Colors.white,
            onChanged: (f) => setState(() => _filter = f!),
            items: const [
              DropdownMenuItem(
                value: TimeFilter.today,
                child: Text("Aujourd'hui"),
              ),
              DropdownMenuItem(
                value: TimeFilter.week,
                child: Text("Cette semaine"),
              ),
              DropdownMenuItem(
                value: TimeFilter.month,
                child: Text("Ce mois-ci"),
              ),
            ],
          ),
        ],
      ),
      body:
          selectedQuiz == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  DropdownButton<String>(
                    value: selectedQuiz,
                    onChanged: (v) => setState(() => selectedQuiz = v),
                    items:
                        quizList
                            .map(
                              (quizId) => DropdownMenuItem(
                                value: quizId,
                                child: Text(quizId),
                              ),
                            )
                            .toList(),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('leaderboard')
                              .where('quizId', isEqualTo: selectedQuiz)
                              .where(
                                'timestamp',
                                isGreaterThanOrEqualTo: filterDate,
                              )
                              .orderBy('score', descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: docs.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final data = docs[index];
                            final isUser = currentUser?.uid == data['userId'];
                            final score = data['score'] ?? 0;
                            final total = data['total'] ?? 1;
                            final username = data['username'] ?? 'Utilisateur';
                            final percent = (score / total * 100)
                                .toStringAsFixed(1);

                            return Card(
                              elevation: 3,
                              color:
                                  isUser
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: _buildRankMedal(index),
                                title: Text(
                                  username,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Score : $score / $total  •  $percent%',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed:
                                      () => _shareRank(
                                        username,
                                        index,
                                        selectedQuiz!,
                                      ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

enum TimeFilter { today, week, month }
