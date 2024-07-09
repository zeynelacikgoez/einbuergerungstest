import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../models/user_profile_model.dart';

class QuizService {
  static Future<List<QuestionModel>> loadQuestions() async {
    List<QuestionModel> allQuestions = [];
    Map<String, QuestionModel> translationMap = {};
    
    // Load German questions
    String deJsonString = await rootBundle.loadString('assets/language/questions-de.json');
    List<dynamic> deJsonList = json.decode(deJsonString);
    allQuestions = deJsonList.map((json) => QuestionModel.fromJson(json)).toList();
    
    // Load Turkish translations
    String trJsonString = await rootBundle.loadString('assets/language/questions-tr.json');
    List<dynamic> trJsonList = json.decode(trJsonString);
    for (var trJson in trJsonList) {
      QuestionModel trQuestion = QuestionModel.fromJson(trJson);
      translationMap[trQuestion.id] = trQuestion;
    }
    
    // Add translations to questions
    for (var question in allQuestions) {
      if (translationMap.containsKey(question.id)) {
        question.translation = translationMap[question.id];
      }
    }
    
    // Load saved question data
    final prefs = await SharedPreferences.getInstance();
    for (var question in allQuestions) {
      String? savedQuestionJson = prefs.getString('question_${question.id}');
      if (savedQuestionJson != null) {
        QuestionModel savedQuestion = QuestionModel.fromJson(json.decode(savedQuestionJson));
        question.difficulty = savedQuestion.difficulty;
        question.lastAnswered = savedQuestion.lastAnswered;
        question.correctStreak = savedQuestion.correctStreak;
        question.incorrectStreak = savedQuestion.incorrectStreak;
        question.easinessFactor = savedQuestion.easinessFactor;
        question.interval = savedQuestion.interval;
      }
    }
    
    return allQuestions;
  }

  static Future<void> saveQuestion(QuestionModel question) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'question_${question.id}';
    await prefs.setString(key, json.encode(question.toJson()));
  }

  static Future<UserProfileModel> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? userProfileJson = prefs.getString('user_profile');
    if (userProfileJson != null) {
      return UserProfileModel.fromJson(json.decode(userProfileJson));
    }
    return UserProfileModel();
  }

  static Future<void> saveUserProfile(UserProfileModel userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(userProfile.toJson()));
  }

  static Future<void> saveProgress(int currentQuestionIndex, int correctAnswers, List<bool?> answerResults) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentQuestionIndex', currentQuestionIndex);
    await prefs.setInt('correctAnswers', correctAnswers);
    await prefs.setStringList('answerResults', answerResults.map((result) => result == null ? 'null' : result.toString()).toList());
  }

  static Future<Map<String, dynamic>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    int currentQuestionIndex = prefs.getInt('currentQuestionIndex') ?? 0;
    int correctAnswers = prefs.getInt('correctAnswers') ?? 0;
    List<String>? savedResults = prefs.getStringList('answerResults');
    List<bool?> answerResults = savedResults?.map((result) => result == 'null' ? null : result == 'true').toList() ?? [];

    return {
      'currentQuestionIndex': currentQuestionIndex,
      'correctAnswers': correctAnswers,
      'answerResults': answerResults,
    };
  }

  static Future<bool> hasActualProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedResults = prefs.getStringList('answerResults');
    return savedResults != null && savedResults.any((result) => result != 'null');
  }

  static Future<bool> isQuizCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedResults = prefs.getStringList('answerResults');
    return savedResults != null && !savedResults.contains('null');
  }
}