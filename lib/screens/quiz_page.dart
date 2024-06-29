import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_mode.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../services/quiz_service.dart';
import '../utils/timer_utils.dart';
import 'overview_page.dart';

class QuizPage extends StatefulWidget {
  final QuizMode mode;
  final bool continueFromLast;

  const QuizPage({super.key, required this.mode, required this.continueFromLast});

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
  late Timer _timer;

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
    if (widget.mode == QuizMode.exam) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  Future<void> _loadQuestions() async {
    final allQuestions = await QuizService.loadQuestions();
    setState(() {
      questions = allQuestions;
      if (widget.mode == QuizMode.exam) {
        questions = questions.take(33).toList();
      }
      answerResults = List.filled(questions.length, null);
    });

    if (widget.continueFromLast) {
      await _loadProgress();
    }
  }

  Future<void> _loadProgress() async {
    final progress = await QuizService.loadProgress();
    setState(() {
      currentQuestionIndex = progress['currentQuestionIndex'];
      correctAnswers = progress['correctAnswers'];
      answerResults = List<bool?>.from(progress['answerResults']);
    });
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      answerResults[currentQuestionIndex] = isCorrect;
      if (isCorrect) {
        correctAnswers++;
      }
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
          title: const Text('Quiz beendet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sie haben $correctAnswers von ${questions.length} Fragen richtig beantwortet.'),
              const SizedBox(height: 16),
              Text('Erfolgsquote: ${(correctAnswers / questions.length * 100).toStringAsFixed(2)}%'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Übersicht'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToOverview();
              },
            ),
            TextButton(
              child: const Text('Zum Hauptmenü'),
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

  Future<bool> _onWillPop() async {
    bool hasAnsweredQuestions = answerResults.any((result) => result != null);

    if (!hasAnsweredQuestions) {
      return true;
    }

    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.mode == QuizMode.training ? 'Trainingsmodus' : 'Prüfungsmodus'} beenden?'),
        content: const Text('Möchten Sie wirklich beenden? Ihr Fortschritt wird gespeichert.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nein'),
          ),
          TextButton(
            onPressed: () {
              QuizService.saveProgress(currentQuestionIndex, correctAnswers, answerResults);
              Navigator.of(context).pop(true);
            },
            child: const Text('Ja'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.mode == QuizMode.training ? 'Trainingsmodus' : 'Prüfungsmodus'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _navigateToOverview,
              tooltip: 'Übersicht',
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