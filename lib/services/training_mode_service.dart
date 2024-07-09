import 'package:flutter/foundation.dart';
import 'dart:math';

class TrainingModeService extends ChangeNotifier {
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _error;
  int _sessionLength = 20; // Default session length

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get sessionLength => _sessionLength;
  QuestionModel? get currentQuestion => 
    _questions.isNotEmpty && _currentIndex < _questions.length 
      ? _questions[_currentIndex] 
      : null;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulating API call to load questions
      await Future.delayed(const Duration(seconds: 2));
      _questions = [
        QuestionModel(id: '1', question: 'Was ist die Hauptstadt von Deutschland?', correctAnswer: 'Berlin'),
        QuestionModel(id: '2', question: 'Welche Farben hat die deutsche Flagge?', correctAnswer: 'Schwarz, Rot, Gold'),
        QuestionModel(id: '3', question: 'Wer ist der aktuelle Bundeskanzler von Deutschland?', correctAnswer: 'Olaf Scholz'),
        QuestionModel(id: '4', question: 'In welchem Jahr wurde die Berliner Mauer gebaut?', correctAnswer: '1961'),
        QuestionModel(id: '5', question: 'Welcher Fluss fließt durch Berlin?', correctAnswer: 'Spree'),
      ];
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

  void resetQuiz() {
    _currentIndex = 0;
    _questions.shuffle(Random());
    notifyListeners();
  }

  void setSessionLength(int length) {
    _sessionLength = length;
    notifyListeners();
  }
}

class QuestionModel {
  final String id;
  final String question;
  final String correctAnswer;

  QuestionModel({required this.id, required this.question, required this.correctAnswer});
}