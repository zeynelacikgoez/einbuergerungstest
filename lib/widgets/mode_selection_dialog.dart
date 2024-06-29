import 'package:flutter/material.dart';
import '../models/quiz_mode.dart';
import '../screens/quiz_page.dart';
import '../screens/training_mode_page.dart';

void showModeSelectionDialog(BuildContext context, QuizMode mode) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(mode == QuizMode.training ? 'Trainingsmodus' : 'Prüfungsmodus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wie möchten Sie fortfahren?'),
            if (mode == QuizMode.training) ...[
              const SizedBox(height: 10),
              const Text('Hinweis: Der Trainingsmodus verwendet einen adaptiven Algorithmus, um Ihr Lernen zu optimieren.'),
            ],
          ],
        ),
        actions: <Widget>[
          if (mode == QuizMode.training)
            TextButton(
              child: const Text('Neues Training starten'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingModePage(),
                  ),
                );
              },
            ),
          TextButton(
            child: const Text('Fortsetzen'),
            onPressed: () {
              Navigator.of(context).pop();
              if (mode == QuizMode.training) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingModePage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage(mode: mode, continueFromLast: true)),
                );
              }
            },
          ),
          TextButton(
            child: const Text('Neu starten'),
            onPressed: () {
              Navigator.of(context).pop();
              if (mode == QuizMode.training) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingModePage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage(mode: mode, continueFromLast: false)),
                );
              }
            },
          ),
        ],
      );
    },
  );
}