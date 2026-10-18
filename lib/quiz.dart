import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'questions_screen.dart';
import 'results_screen.dart';
import 'start_screen.dart';

enum QuizScreen { start, questions, results }

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  QuizScreen activeScreen = QuizScreen.start;
  final List<String> selectedAnswers = [];

  void startQuiz() {
    setState(() {
      selectedAnswers.clear();
      activeScreen = QuizScreen.questions;
    });
  }

  void chooseAnswer(String answer) {
    if (activeScreen != QuizScreen.questions) return;
    setState(() {
      selectedAnswers.add(answer);
      if (selectedAnswers.length == questions.length) {
        activeScreen = QuizScreen.results;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget screen = switch (activeScreen) {
      QuizScreen.start => StartScreen(startQuiz),
      QuizScreen.questions => QuestionsScreen(
        key: ValueKey(selectedAnswers.length),
        questionIndex: selectedAnswers.length,
        onSelectAnswer: chooseAnswer,
      ),
      QuizScreen.results => ResultsScreen(
        selectedAnswers: selectedAnswers,
        onRestart: startQuiz,
      ),
    };

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: screen,
            ),
          ),
        ),
      ),
    );
  }
}
