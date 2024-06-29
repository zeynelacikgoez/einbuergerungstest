import 'package:flutter/foundation.dart';

class QuestionModel {
  final String id;
  final String part;
  final String section;
  final String task;
  final Map<String, dynamic> question;
  final List<Map<String, dynamic>> options;
  int difficulty;
  DateTime? lastAnswered;
  int correctStreak;
  int incorrectStreak;
  double easinessFactor;
  int interval;

  QuestionModel({
    required this.id,
    required this.part,
    required this.section,
    required this.task,
    required this.question,
    required this.options,
    this.difficulty = 5,
    this.lastAnswered,
    this.correctStreak = 0,
    this.incorrectStreak = 0,
    this.easinessFactor = 2.5,
    this.interval = 1,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      part: json['part'],
      section: json['section'],
      task: json['task'],
      question: json['question'],
      options: List<Map<String, dynamic>>.from(json['options']),
      difficulty: json['difficulty'] ?? 5,
      lastAnswered: json['lastAnswered'] != null ? DateTime.parse(json['lastAnswered']) : null,
      correctStreak: json['correctStreak'] ?? 0,
      incorrectStreak: json['incorrectStreak'] ?? 0,
      easinessFactor: json['easinessFactor'] ?? 2.5,
      interval: json['interval'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'part': part,
      'section': section,
      'task': task,
      'question': question,
      'options': options,
      'difficulty': difficulty,
      'lastAnswered': lastAnswered?.toIso8601String(),
      'correctStreak': correctStreak,
      'incorrectStreak': incorrectStreak,
      'easinessFactor': easinessFactor,
      'interval': interval,
    };
  }

  QuestionModel copyWith({
    String? id,
    String? part,
    String? section,
    String? task,
    Map<String, dynamic>? question,
    List<Map<String, dynamic>>? options,
    int? difficulty,
    DateTime? lastAnswered,
    int? correctStreak,
    int? incorrectStreak,
    double? easinessFactor,
    int? interval,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      part: part ?? this.part,
      section: section ?? this.section,
      task: task ?? this.task,
      question: question ?? this.question,
      options: options ?? this.options,
      difficulty: difficulty ?? this.difficulty,
      lastAnswered: lastAnswered ?? this.lastAnswered,
      correctStreak: correctStreak ?? this.correctStreak,
      incorrectStreak: incorrectStreak ?? this.incorrectStreak,
      easinessFactor: easinessFactor ?? this.easinessFactor,
      interval: interval ?? this.interval,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          part == other.part &&
          section == other.section &&
          task == other.task &&
          mapEquals(question, other.question) &&
          listEquals(options, other.options) &&
          difficulty == other.difficulty &&
          lastAnswered == other.lastAnswered &&
          correctStreak == other.correctStreak &&
          incorrectStreak == other.incorrectStreak &&
          easinessFactor == other.easinessFactor &&
          interval == other.interval;

  @override
  int get hashCode =>
      id.hashCode ^
      part.hashCode ^
      section.hashCode ^
      task.hashCode ^
      question.hashCode ^
      options.hashCode ^
      difficulty.hashCode ^
      lastAnswered.hashCode ^
      correctStreak.hashCode ^
      incorrectStreak.hashCode ^
      easinessFactor.hashCode ^
      interval.hashCode;

  @override
  String toString() {
    return 'QuestionModel(id: $id, part: $part, section: $section, task: $task, difficulty: $difficulty, lastAnswered: $lastAnswered, correctStreak: $correctStreak, incorrectStreak: $incorrectStreak, easinessFactor: $easinessFactor, interval: $interval)';
  }
}