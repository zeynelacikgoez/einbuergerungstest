import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/training_mode_service.dart';
import '../services/theme_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final trainingModeService = Provider.of<TrainingModeService>(context);
    final themeService = Provider.of<ThemeService>(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Einstellungen',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSettingSection(
                  context,
                  title: 'Sprache & Übersetzung',
                  children: [
                    _buildSettingItem(
                      context,
                      title: 'App-Sprache',
                      child: DropdownButton<Locale>(
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
                    _buildSettingItem(
                      context,
                      title: 'Übersetzungssprache',
                      child: DropdownButton<String>(
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
                  ],
                ),
                _buildSettingSection(
                  context,
                  title: 'Trainingsmodus',
                  children: [
                    _buildSettingItem(
                      context,
                      title: 'Sitzungslänge',
                      child: DropdownButton<int>(
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
                            child: Text('$value Fragen'),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                _buildSettingSection(
                  context,
                  title: 'Darstellung',
                  children: [
                    _buildSettingItem(
                      context,
                      title: 'Dunkler Modus',
                      child: Switch(
                        value: themeService.darkMode,
                        onChanged: (bool value) {
                          themeService.toggleTheme();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          child,
        ],
      ),
    );
  }
}