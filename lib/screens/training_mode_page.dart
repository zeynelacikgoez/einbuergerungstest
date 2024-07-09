import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/training_mode_service.dart';
import '../services/language_service.dart';
import '../models/question_model.dart';
import 'overview_page.dart';

class TrainingModePage extends StatelessWidget {
  const TrainingModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingsmodus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => _navigateToOverview(context),
            tooltip: 'Fragenübersicht',
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () => _showTranslation(context, languageService),
            tooltip: 'Übersetzen',
          ),
        ],
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
                  currentQuestion.question['text'] ?? '',
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

  void _navigateToOverview(BuildContext context) {
    final trainingModeService = Provider.of<TrainingModeService>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverviewPage(
          questions: trainingModeService.questions,
          answerResults: trainingModeService.answerResults,
          onQuestionSelected: (index) {
            trainingModeService.goToQuestion(index);
            Navigator.pop(context);
          },
          onRestart: () {
            trainingModeService.resetQuiz();
            Navigator.pop(context);
          },
          isCompleted: false,
        ),
      ),
    );
  }

  void _showTranslation(BuildContext context, LanguageService languageService) {
    final trainingModeService = Provider.of<TrainingModeService>(context, listen: false);
    final currentQuestion = trainingModeService.currentQuestion;
    if (currentQuestion != null) {
      final translatedText = languageService.translate(currentQuestion.question['text'] ?? '');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Übersetzung (${languageService.translationLanguage})'),
          content: Text(translatedText),
          actions: [
            TextButton(
              child: const Text('Schließen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}