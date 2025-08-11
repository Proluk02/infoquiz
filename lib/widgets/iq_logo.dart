// Widget qui affiche le logo de l'application (icône + texte)
import 'package:flutter/material.dart';

class IQLogo extends StatelessWidget {
  const IQLogo({Key? key, required int size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bloc : Icône principale du logo
        Icon(Icons.quiz, size: 80, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        // Bloc : Texte du logo
        Text('InfoQuiz', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
