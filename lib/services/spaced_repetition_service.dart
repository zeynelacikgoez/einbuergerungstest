import 'dart:math';
import '../../models/question_model.dart';

class SpacedRepetitionService {
  // Konstanten für den SuperMemo-2 Algorithmus
  static const double _minEaseFactor = 1.3;
  static const int _maxInterval = 365; // Maximales Intervall in Tagen

  // Berechnet das nächste Wiederholungsintervall basierend auf der SuperMemo-2 Methode
  static int calculateNextInterval(QuestionModel question, int grade) {
    if (grade < 3) {
      question.correctStreak = 0;
      return 1;
    }

    if (question.correctStreak == 0) {
      question.correctStreak = 1;
      return 1;
    } else if (question.correctStreak == 1) {
      question.correctStreak = 2;
      return 6;
    }

    int nextInterval = (question.interval * question.easinessFactor).round();
    nextInterval = min(nextInterval, _maxInterval);
    question.correctStreak++;

    return nextInterval;
  }

  // Aktualisiert den Schwierigkeitsgrad (Easiness Factor) der Frage
  static void updateEasinessFactor(QuestionModel question, int grade) {
    double newEF = question.easinessFactor + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    question.easinessFactor = max(_minEaseFactor, newEF);
  }

  // Bestimmt, ob eine Frage zur Wiederholung fällig ist
  static bool isDue(QuestionModel question) {
    if (question.lastAnswered == null) return true;
    int daysSinceLastAnswered = DateTime.now().difference(question.lastAnswered!).inDays;
    return daysSinceLastAnswered >= question.interval;
  }

  // Wählt die nächste Frage für die Wiederholung aus
  static QuestionModel? selectNextQuestion(List<QuestionModel> questions) {
    List<QuestionModel> dueQuestions = questions.where((q) => isDue(q)).toList();
    if (dueQuestions.isEmpty) return null;
    
    dueQuestions.sort((a, b) {
      int daysSinceLastA = a.lastAnswered != null ? DateTime.now().difference(a.lastAnswered!).inDays : 0;
      int daysSinceLastB = b.lastAnswered != null ? DateTime.now().difference(b.lastAnswered!).inDays : 0;
      return daysSinceLastB.compareTo(daysSinceLastA);
    });

    return dueQuestions.first;
  }
}