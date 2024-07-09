import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_mode.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../services/quiz_service.dart';
import '../services/language_service.dart';
import '../utils/timer_utils.dart';
import 'overview_page.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final QuizMode mode;
  final bool continueFromLast;

  const QuizPage({Key? key, required this.mode, required this.continueFromLast}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuestionModel> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<bool?> answerResults = [];
  bool showFeedback = false;
  bool? isLastAnswerCorrect;
  DateTime? examStartTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    if (widget.mode == QuizMode.exam) {
      examStartTime = DateTime.now();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final allQuestions = await QuizService.loadQuestions();
      setState(() {
        questions = widget.mode == QuizMode.exam ? allQuestions.take(33).toList() : allQuestions;
        answerResults = List.filled(questions.length, null);
      });

      if (widget.continueFromLast) {
        await _loadProgress();
      }
    } catch (e) {
      print('Error loading questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    }
  }

  Future<void> _loadProgress() async {
    try {
      final progress = await QuizService.loadProgress();
      setState(() {
        currentQuestionIndex = progress['currentQuestionIndex'];
        correctAnswers = progress['correctAnswers'];
        answerResults = List<bool?>.from(progress['answerResults']);
      });
    } catch (e) {
      print('Error loading progress: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load progress: $e')),
      );
    }
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      answerResults[currentQuestionIndex] = isCorrect;
      if (isCorrect) correctAnswers++;
      showFeedback = true;
      isLastAnswerCorrect = isCorrect;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showFeedback = false;
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          _showResultDialog();
        }
      });
    });

    QuizService.saveProgress(currentQuestionIndex, correctAnswers, answerResults);
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You answered $correctAnswers out of ${questions.length} questions correctly.'),
              const SizedBox(height: 16),
              Text('Success rate: ${(correctAnswers / questions.length * 100).toStringAsFixed(2)}%'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Overview'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToOverview();
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToOverview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverviewPage(
          questions: questions,
          answerResults: answerResults,
          onQuestionSelected: (index) {
            setState(() {
              currentQuestionIndex = index;
            });
            Navigator.pop(context);
          },
          onRestart: () {
            setState(() {
              currentQuestionIndex = 0;
              correctAnswers = 0;
              answerResults = List.filled(questions.length, null);
              showFeedback = false;
              isLastAnswerCorrect = null;
            });
            Navigator.pop(context);
          },
          isCompleted: currentQuestionIndex == questions.length - 1 && answerResults.last != null,
        ),
      ),
    );
  }

  void _showTranslation(BuildContext context, LanguageService languageService) {
    final currentQuestion = questions[currentQuestionIndex];
    final translatedText = currentQuestion.question['translation'] ?? 'Keine Übersetzung verfügbar';
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

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final languageService = Provider.of<LanguageService>(context);

    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit ${widget.mode == QuizMode.training ? 'Training' : 'Exam'} Mode?'),
            content: const Text('Are you sure you want to exit? Your progress will be saved.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  QuizService.saveProgress(currentQuestionIndex, correctAnswers, answerResults);
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.mode == QuizMode.training ? 'Training Mode' : 'Exam Mode'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _navigateToOverview,
              tooltip: 'Overview',
            ),
            IconButton(
              icon: const Icon(Icons.translate),
              onPressed: () => _showTranslation(context, languageService),
              tooltip: 'Übersetzen',
            ),
            if (widget.mode == QuizMode.exam)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    getRemainingTime(examStartTime),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
        body: QuestionWidget(
          question: questions[currentQuestionIndex],
          showFeedback: showFeedback,
          isLastAnswerCorrect: isLastAnswerCorrect,
          onAnswerSelected: _checkAnswer,
        ),
      ),
    );
  }
}