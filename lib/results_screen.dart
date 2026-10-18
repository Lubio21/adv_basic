import 'package:flutter/material.dart';
import 'data/questions.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.selectedAnswers,
    required this.onRestart,
  });

  final List<String> selectedAnswers;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final correctCount = questions.asMap().entries.where((entry) {
      return selectedAnswers[entry.key] == entry.value.answers.first;
    }).length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Výsledky kvízu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Správne odpovede: $correctCount z ${questions.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ...questions.asMap().entries.map((entry) {
                  final answer = selectedAnswers[entry.key];
                  // Prvá odpoveď v dátovom súbore je vždy správna.
                  final correctAnswer = entry.value.answers.first;
                  final isCorrect = answer == correctAnswer;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${entry.key + 1}. ${entry.value.text}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Tvoja odpoveď: $answer'),
                          Text(isCorrect ? 'Správne' : 'Nesprávne'),
                          if (!isCorrect)
                            Text('Správna odpoveď: $correctAnswer'),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRestart,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}
