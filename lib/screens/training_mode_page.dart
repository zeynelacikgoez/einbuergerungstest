import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/training_mode_service.dart';

class TrainingModePage extends StatelessWidget {
  const TrainingModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingsmodus'),
      ),
      body: Consumer<TrainingModeService>(
        builder: (context, trainingModeService, child) {
          if (trainingModeService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (trainingModeService.error != null) {
            return Center(child: Text('Fehler: ${trainingModeService.error}'));
          }

          final currentQuestion = trainingModeService.currentQuestion;
          if (currentQuestion == null) {
            return const Center(child: Text('Keine Fragen verfügbar'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frage ${trainingModeService.currentIndex + 1} von ${trainingModeService.totalQuestions}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  currentQuestion.question,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  child: const Text('Nächste Frage'),
                  onPressed: () {
                    if (trainingModeService.currentIndex < trainingModeService.totalQuestions - 1) {
                      trainingModeService.nextQuestion();
                    } else {
                      // Quiz beendet
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Training abgeschlossen'),
                          content: const Text('Sie haben alle Fragen beantwortet.'),
                          actions: [
                            TextButton(
                              child: const Text('Neustart'),
                              onPressed: () {
                                trainingModeService.resetQuiz();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Hauptmenü'),
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}