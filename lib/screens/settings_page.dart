import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/training_mode_service.dart';
import '../services/theme_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildLanguageSection(context)),
            SliverToBoxAdapter(child: _buildTrainingSection(context)),
            SliverToBoxAdapter(child: _buildAppearanceSection(context)),
            SliverToBoxAdapter(child: _buildAboutSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.language,
      title: 'Sprache & Übersetzung',
      children: [
        Consumer<LanguageService>(
          builder: (context, languageService, child) => _buildSettingItem(
            context: context,
            title: 'App-Sprache',
            subtitle: languageService.getLanguageName(languageService.currentLocale),
            onTap: () => _showLanguageDialog(context, languageService),
          ),
        ),
        Consumer<LanguageService>(
          builder: (context, languageService, child) => _buildSettingItem(
            context: context,
            title: 'Übersetzungssprache',
            subtitle: languageService.translationLanguage,
            onTap: () => _showTranslationLanguageDialog(context, languageService),
          ),
        ),
      ],
      showDivider: true,
    );
  }

  Widget _buildTrainingSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.fitness_center,
      title: 'Trainingsmodus',
      children: [
        Consumer<TrainingModeService>(
          builder: (context, trainingModeService, child) => _buildSettingItem(
            context: context,
            title: 'Sitzungslänge',
            subtitle: '${trainingModeService.sessionLength} Fragen',
            onTap: () => _showSessionLengthDialog(context, trainingModeService),
          ),
        ),
      ],
      showDivider: true,
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.palette,
      title: 'Darstellung',
      children: [
        Consumer<ThemeService>(
          builder: (context, themeService, child) => _buildSwitchItem(
            context: context,
            title: 'Dunkler Modus',
            subtitle: themeService.darkMode ? 'Aktiviert' : 'Deaktiviert',
            value: themeService.darkMode,
            onChanged: (value) => themeService.toggleTheme(),
          ),
        ),
      ],
      showDivider: true,
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.info_outline,
      title: 'Über die App',
      children: [
        _buildSettingItem(
          context: context,
          title: 'Version',
          subtitle: '1.0.0',
          onTap: () {},
        ),
        _buildSettingItem(
          context: context,
          title: 'Lizenzen',
          subtitle: 'Open-Source Lizenzen',
          onTap: () => showLicensePage(context: context),
        ),
      ],
      showDivider: false,
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
    required bool showDivider,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.secondary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        ...children,
        if (showDivider) _buildSubtleDivider(context),
      ],
    );
  }

  Widget _buildSubtleDivider(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).dividerColor.withOpacity(0.3),
            Theme.of(context).dividerColor.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.1, 0.9, 1.0],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageService languageService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'App-Sprache auswählen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  children: languageService.supportedLocales.map((locale) {
                    return ListTile(
                      title: Text(languageService.getLanguageName(locale)),
                      trailing: languageService.currentLocale == locale
                          ? Icon(Icons.check, color: Theme.of(context).colorScheme.secondary)
                          : null,
                      onTap: () {
                        languageService.changeLanguage(locale);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTranslationLanguageDialog(BuildContext context, LanguageService languageService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Übersetzungssprache auswählen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  children: ['Türkisch', 'Arabisch'].map((language) {
                    return ListTile(
                      title: Text(language),
                      trailing: languageService.translationLanguage == language
                          ? Icon(Icons.check, color: Theme.of(context).colorScheme.secondary)
                          : null,
                      onTap: () {
                        languageService.setTranslationLanguage(language);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSessionLengthDialog(BuildContext context, TrainingModeService trainingModeService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sitzungslänge auswählen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [10, 20, 30, 40, 50].map((length) {
                    return ListTile(
                      title: Text('$length Fragen'),
                      trailing: trainingModeService.sessionLength == length
                          ? Icon(Icons.check, color: Theme.of(context).colorScheme.secondary)
                          : null,
                      onTap: () {
                        trainingModeService.setSessionLength(length);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}