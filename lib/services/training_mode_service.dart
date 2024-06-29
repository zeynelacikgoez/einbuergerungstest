import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../models/user_profile_model.dart';
import 'quiz_service.dart';
import 'spaced_repetition_service.dart';

class TrainingModeService extends ChangeNotifier {
  List<QuestionModel> questions = [];
  late UserProfileModel userProfile;
  int sessionLength = 20;
  bool _isInitialized = false;

  TrainingModeService();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    questions = await QuizService.loadQuestions();
    userProfile = await QuizService.loadUserProfile();
    _isInitialized = true;
    notifyListeners();
  }

  void setSessionLength(int length) {
    sessionLength = length;
    notifyListeners();
  }

  QuestionModel? selectNextQuestion() {
    if (!_isInitialized) throw StateError('TrainingModeService not initialized');
    
    QuestionModel? nextQuestion = SpacedRepetitionService.selectNextQuestion(questions);
    if (nextQuestion == null) {
      return _introduceNewQuestion();
    }
    return nextQuestion;
  }

  QuestionModel? _introduceNewQuestion() {
    List<QuestionModel> newQuestions = questions.where((q) => q.lastAnswered == null).toList();
    if (newQuestions.isEmpty) return null;
    return _selectAppropriateDifficulty(newQuestions);
  }

  QuestionModel _selectAppropriateDifficulty(List<QuestionModel> questions) {
    double avgStrength = userProfile.strengths.isNotEmpty
        ? userProfile.strengths.values.reduce((a, b) => a + b) / userProfile.strengths.length
        : 5;
    int targetDifficulty = min(10, max(1, (avgStrength + 1).round()));
    questions.sort((a, b) => (a.difficulty - targetDifficulty).abs().compareTo((b.difficulty - targetDifficulty).abs()));
    return questions.first;
  }

  void updateQuestion(QuestionModel question, bool correct) {
    int grade = correct ? 5 : 2; // Simplified grading: correct = 5, incorrect = 2
    
    question.interval = SpacedRepetitionService.calculateNextInterval(question, grade);
    SpacedRepetitionService.updateEasinessFactor(question, grade);
    question.lastAnswered = DateTime.now();

    QuizService.saveQuestion(question);
    notifyListeners();
  }

  void updateUserProfile(QuestionModel question, bool correct) {
    String topic = '${question.part}-${question.section}';
    if (correct) {
      userProfile.strengths[topic] = min(10, (userProfile.strengths[topic] ?? 5) + 0.1);
      userProfile.weaknesses[topic] = max(1, (userProfile.weaknesses[topic] ?? 5) - 0.2);
    } else {
      userProfile.weaknesses[topic] = min(10, (userProfile.weaknesses[topic] ?? 5) + 0.2);
      userProfile.strengths[topic] = max(1, (userProfile.strengths[topic] ?? 5) - 0.1);
    }
    QuizService.saveUserProfile(userProfile);
    notifyListeners();
  }

  Future<void> startNewSession() async {
    if (!_isInitialized) await initialize();
    notifyListeners();
  }

  Future<void> loadProgress() async {
    if (!_isInitialized) await initialize();
    notifyListeners();
  }
}