import 'package:flutter/material.dart';
import 'answer_button.dart';
import 'data/questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.questionIndex,
    required this.onSelectAnswer,
  });

  final int questionIndex;
  final ValueChanged<String> onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  // Zamiešame kópiu odpovedí iba pri otvorení otázky.
  late final List<String> answers = questions[widget.questionIndex]
      .getShuffledAnswers();
  bool answered = false;

  void selectAnswer(String answer) {
    if (answered) return;
    answered = true;
    widget.onSelectAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[widget.questionIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Otázka ${widget.questionIndex + 1} z ${questions.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (widget.questionIndex + 1) / questions.length,
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
          const SizedBox(height: 28),
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...answers.map(
            (answer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerButton(
                answerText: answer,
                onTap: () => selectAnswer(answer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
