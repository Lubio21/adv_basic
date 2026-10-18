import 'package:adv_basic/answer_button.dart';
import 'package:adv_basic/data/questions.dart';
import 'package:adv_basic/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Complete quiz, review mixed answers, and restart with clean state',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Start Quiz'), findsOneWidget);
      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();

      for (var index = 0; index < questions.length; index++) {
        expect(
          find.text('Otázka ${index + 1} z ${questions.length}'),
          findsOneWidget,
        );
        expect(find.text(questions[index].text), findsOneWidget);
        expect(find.byType(AnswerButton), findsNWidgets(4));
        final answer = questions[index].answers[index.isEven ? 0 : 1];
        await tester.ensureVisible(find.text(answer));
        await tester.tap(find.text(answer));
        await tester.pumpAndSettle();
      }

      expect(find.text('Výsledky kvízu'), findsOneWidget);
      expect(
        find.text('Správne odpovede: 3 z ${questions.length}'),
        findsOneWidget,
      );
      final lastAnswer = find.text(
        'Správna odpoveď: ${questions.last.answers.first}',
      );
      await tester.scrollUntilVisible(
        lastAnswer,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(lastAnswer, findsOneWidget);
      await tester.tap(find.text('Restart Quiz'));
      await tester.pumpAndSettle();
      expect(find.text('Otázka 1 z ${questions.length}'), findsOneWidget);

      for (final question in questions) {
        await tester.ensureVisible(find.text(question.answers.first));
        await tester.tap(find.text(question.answers.first));
        await tester.pumpAndSettle();
      }
      expect(
        find.text(
          'Správne odpovede: ${questions.length} z ${questions.length}',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Questions fit a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Start Quiz'));
    await tester.tap(find.text('Start Quiz'));
    await tester.pumpAndSettle();
    for (final question in questions) {
      await tester.ensureVisible(find.text(question.answers.first));
      await tester.tap(find.text(question.answers.first));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Výsledky kvízu'), findsOneWidget);
  });
}
