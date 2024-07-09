import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/question_model.dart';
import '../services/quiz_service.dart';

class TrainingModeService extends ChangeNotifier {
  List<QuestionModel> _questions = [];
  List<bool?> _answerResults = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _error;
  int _sessionLength = 20; // Default session length

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get sessionLength => _sessionLength;
  List<QuestionModel> get questions => _questions;
  List<bool?> get answerResults => _answerResults;
  QuestionModel? get currentQuestion => 
    _questions.isNotEmpty && _currentIndex < _questions.length 
      ? _questions[_currentIndex] 
      : null;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Lade die Fragen aus dem QuizService
      _questions = await QuizService.loadQuestions();
      if (_questions.isEmpty) {
        throw Exception('Keine Fragen verfügbar');
      }
      _answerResults = List.filled(_questions.length, null);
      _questions.shuffle(Random());
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentIndex = 0;
    _questions.shuffle(Random());
    _answerResults = List.filled(_questions.length, null);
    notifyListeners();
  }

  void setSessionLength(int length) {
    _sessionLength = length;
    notifyListeners();
  }

  void answerQuestion(bool isCorrect) {
    if (_currentIndex < _answerResults.length) {
      _answerResults[_currentIndex] = isCorrect;
      notifyListeners();
    }
  }

  bool isQuizCompleted() {
    return _currentIndex >= _questions.length - 1;
  }

  int getCorrectAnswersCount() {
    return _answerResults.where((result) => result == true).length;
  }
}