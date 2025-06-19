import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infoquiz'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_2_outlined,
              size: 60,
              color: Color(0xFFA6F100),
            ),
            const SizedBox(height: 20),
            Text(
              'FLUTTER QUIZ',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Test your knowledge of Flutter!',
              style: TextStyle(fontSize: 16, color: Color(0xFF0F2A30)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: () {}, child: const Text('Start Quiz')),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1C4D57),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('Options'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1C4D57),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.info_outline),
              onPressed: () {},
              label: const Text('About'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close),
              onPressed: () {},
              label: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
