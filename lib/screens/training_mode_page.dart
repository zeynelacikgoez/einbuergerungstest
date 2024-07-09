import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/training_mode_service.dart';
import '../services/language_service.dart';
import 'overview_page.dart';
import '../widgets/question_widget.dart';

class TrainingModePage extends StatefulWidget {
  const TrainingModePage({Key? key}) : super(key: key);

  @override
  State<TrainingModePage> createState() => _TrainingModePageState();
}

class _TrainingModePageState extends State<TrainingModePage> {
  bool showTranslation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrainingModeService>(context, listen: false).initialize();
    });
  }

  void _toggleTranslation() {
    setState(() {
      showTranslation = !showTranslation;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(showTranslation ? Icons.language : Icons.translate),
            onPressed: _toggleTranslation,
            tooltip: showTranslation ? 'Übersetzung ausblenden' : 'Übersetzen',
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

          return QuestionWidget(
            question: currentQuestion,
            showFeedback: false,
            isLastAnswerCorrect: null,
            onAnswerSelected: (bool isCorrect) {
              trainingModeService.answerQuestion(isCorrect);
              if (trainingModeService.isQuizCompleted()) {
                _showCompletionDialog(context, trainingModeService);
              } else {
                trainingModeService.nextQuestion();
              }
            },
            showTranslation: showTranslation,
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

  void _showCompletionDialog(BuildContext context, TrainingModeService trainingModeService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training abgeschlossen'),
        content: Text('Sie haben ${trainingModeService.getCorrectAnswersCount()} von ${trainingModeService.totalQuestions} Fragen richtig beantwortet.'),
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
}