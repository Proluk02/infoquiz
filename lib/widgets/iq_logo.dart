import 'package:flutter/material.dart';

class IQLogo extends StatelessWidget {
  const IQLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.quiz, size: 80, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text('InfoQuiz', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
