import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('de');
  String _translationLanguage = 'Türkisch';

  Locale get currentLocale => _currentLocale;
  String get translationLanguage => _translationLanguage;

  final List<Locale> supportedLocales = [
    const Locale('de'),
    const Locale('en'),
    const Locale('tr'),
    const Locale('ar'),
  ];

  void changeLanguage(Locale newLocale) {
    if (supportedLocales.contains(newLocale)) {
      _currentLocale = newLocale;
      notifyListeners();
    }
  }

  void setTranslationLanguage(String language) {
    _translationLanguage = language;
    notifyListeners();
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }

  // Hier würde die Logik für die Übersetzung implementiert werden
  String translate(String text) {
    // Platzhalter für die Übersetzungslogik
    return "Übersetzter Text: $text";
  }
}