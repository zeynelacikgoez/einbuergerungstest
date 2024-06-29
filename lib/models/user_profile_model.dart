import 'package:flutter/foundation.dart';

class UserProfileModel {
  Map<String, double> strengths;
  Map<String, double> weaknesses;
  String? learningStyle;

  UserProfileModel({
    this.strengths = const {},
    this.weaknesses = const {},
    this.learningStyle,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      strengths: Map<String, double>.from(json['strengths'] ?? {}),
      weaknesses: Map<String, double>.from(json['weaknesses'] ?? {}),
      learningStyle: json['learningStyle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strengths': strengths,
      'weaknesses': weaknesses,
      'learningStyle': learningStyle,
    };
  }

  UserProfileModel copyWith({
    Map<String, double>? strengths,
    Map<String, double>? weaknesses,
    String? learningStyle,
  }) {
    return UserProfileModel(
      strengths: strengths ?? Map<String, double>.from(this.strengths),
      weaknesses: weaknesses ?? Map<String, double>.from(this.weaknesses),
      learningStyle: learningStyle ?? this.learningStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModel &&
          runtimeType == other.runtimeType &&
          mapEquals(strengths, other.strengths) &&
          mapEquals(weaknesses, other.weaknesses) &&
          learningStyle == other.learningStyle;

  @override
  int get hashCode => strengths.hashCode ^ weaknesses.hashCode ^ learningStyle.hashCode;

  @override
  String toString() {
    return 'UserProfileModel(strengths: $strengths, weaknesses: $weaknesses, learningStyle: $learningStyle)';
  }
}