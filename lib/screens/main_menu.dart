import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/mode_selection_dialog.dart';
import '../models/quiz_mode.dart';
import 'settings_page.dart';
import '../services/quiz_service.dart';
import '../services/training_mode_service.dart';
import '../services/theme_service.dart';
import 'quiz_page.dart';
import 'training_mode_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeService = Provider.of<ThemeService>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, themeService),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRecentlyPlayed(context),
                      const SizedBox(height: 24),
                      _buildTopMixtapes(context),
                      const SizedBox(height: 24),
                      _buildListenAgain(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeService themeService) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(themeService.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeService.toggleTheme();
            },
          ),
          _buildFilterButton('Sprache', theme),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schnellzugriff',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecentlyPlayedItem('Alle Fragen', 'assets/image/img001.png', () => _startTrainingMode(context), theme),
              _buildRecentlyPlayedItem('Integrationskurse', 'assets/image/img002.png', () {}, theme),
              _buildRecentlyPlayedItem('Statistik', 'assets/image/img003.png', () {}, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedItem(String title, String imagePath, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMixtapes(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optionen',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildTopMixtapeItem('Trainingsmodus', 'Lernen nach Spaced Repetition', 'assets/image/img004.png', () => _startTrainingMode(context), theme),
        const SizedBox(height: 16),
        _buildTopMixtapeItem('Prüfungsmodus', 'Simulation der Prüfung', 'assets/image/img005.png', () => _showModeSelectionDialog(context, QuizMode.exam), theme),
        const SizedBox(height: 16),
        _buildTopMixtapeItem('Listen', 'Eigene Listen erstellen und verwalten', 'assets/image/img006.png', () {}, theme),
      ],
    );
  }

  Widget _buildTopMixtapeItem(String title, String subtitle, String imagePath, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListenAgain(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wieder lernen',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildListenAgainItem('Markiert', 'Markierte Fragen zum Lernen', 'assets/image/img007.png', () {}, theme),
        const SizedBox(height: 16),
        _buildListenAgainItem('Fehlgeschlagen', 'Falsch beantwortete Fragen', 'assets/image/img008.png', () {}, theme),
      ],
    );
  }

  Widget _buildListenAgainItem(String title, String subtitle, String imagePath, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.home, 'Start', theme),
            _buildNavBarItem(Icons.chat_bubble, 'Chat', theme),
            _buildNavBarItem(Icons.settings, 'Optionen', theme, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, ThemeData theme, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  void _startTrainingMode(BuildContext context) async {
    final trainingModeService = Provider.of<TrainingModeService>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Trainingsmodus wird geladen'),
                const SizedBox(height: 20),
                SizedBox(
                  width: 60,
                  child: const LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      await trainingModeService.initialize();
      Navigator.of(context).pop(); // Close loading dialog
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainingModePage()),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden des Trainingsmodus: $e')),
        );
      }
    }
  }

  void _showModeSelectionDialog(BuildContext context, QuizMode mode) async {
    bool hasActualProgress = await QuizService.hasActualProgress();
    bool isCompleted = await QuizService.isQuizCompleted();

    if (!context.mounted) return;

    if (hasActualProgress && !isCompleted) {
      showModeSelectionDialog(context, mode);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(mode: mode, continueFromLast: false)),
      );
    }
  }
}