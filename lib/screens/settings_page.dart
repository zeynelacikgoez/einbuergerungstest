import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../services/training_mode_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final trainingModeService = Provider.of<TrainingModeService>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.appLanguageSelection),
            trailing: DropdownButton<Locale>(
              value: languageService.currentLocale,
              onChanged: (Locale? newValue) {
                if (newValue != null) {
                  languageService.changeLanguage(newValue);
                }
              },
              items: languageService.supportedLocales.map<DropdownMenuItem<Locale>>((Locale locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(languageService.getLanguageName(locale)),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text(localizations.translationLanguageSelection),
            trailing: DropdownButton<String>(
              value: languageService.translationLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  languageService.setTranslationLanguage(newValue);
                }
              },
              items: ['Türkisch', 'Arabisch'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text(localizations.sessionLengthSelection),
            trailing: DropdownButton<int>(
              value: trainingModeService.sessionLength,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  trainingModeService.setSessionLength(newValue);
                }
              },
              items: [10, 20, 30, 40, 50]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value ${localizations.questions}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}