import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/question_model.dart';
import '../services/training_mode_service.dart';
import '../widgets/question_widget.dart';

class TrainingModePage extends StatefulWidget {
  const TrainingModePage({Key? key}) : super(key: key);

  @override
  _TrainingModePageState createState() => _TrainingModePageState();
}

class _TrainingModePageState extends State<TrainingModePage> {
  late TrainingModeService _trainingModeService;
  QuestionModel? currentQuestion;
  int questionsAnswered = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _trainingModeService = Provider.of<TrainingModeService>(context, listen: false);
    _initializeTrainingSession();
  }

  Future<void> _initializeTrainingSession() async {
    await _trainingModeService.initialize();
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    setState(() {
      isLoading = true;
    });
    
    currentQuestion = _trainingModeService.selectNextQuestion();
    
    setState(() {
      isLoading = false;
    });
  }

  void _handleAnswer(bool isCorrect) {
    if (currentQuestion != null) {
      _trainingModeService.updateQuestion(currentQuestion!, isCorrect);
      _trainingModeService.updateUserProfile(currentQuestion!, isCorrect);
    }

    setState(() {
      questionsAnswered++;
    });

    if (questionsAnswered < _trainingModeService.sessionLength) {
      _loadNextQuestion();
    } else {
      _showSessionCompleteDialog();
    }
  }

  void _showSessionCompleteDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.trainingModeComplete),
          content: Text(localizations.trainingModeCompleteMessage),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.backToMainMenu),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            TextButton(
              child: Text(localizations.startNewSession),
              onPressed: () {
                setState(() {
                  questionsAnswered = 0;
                  isLoading = true;
                });
                _initializeTrainingSession();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.trainingMode),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentQuestion == null
              ? Center(child: Text(localizations.noQuestionsAvailable))
              : Column(
                  children: [
                    LinearProgressIndicator(
                      value: questionsAnswered / _trainingModeService.sessionLength,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${questionsAnswered + 1} / ${_trainingModeService.sessionLength}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: QuestionWidget(
                        question: currentQuestion!,
                        onAnswerSelected: _handleAnswer,
                      ),
                    ),
                  ],
                ),
    );
  }
}