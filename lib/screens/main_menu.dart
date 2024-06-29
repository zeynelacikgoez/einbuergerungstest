import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../widgets/mode_selection_dialog.dart';
import '../models/quiz_mode.dart';
import 'settings_page.dart';
import '../services/quiz_service.dart';
import '../services/training_mode_service.dart';
import 'quiz_page.dart';
import 'training_mode_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(localizations.trainingMode),
              onPressed: () => _startTrainingMode(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(localizations.examMode),
              onPressed: () => _showModeSelectionDialog(context, QuizMode.exam),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(localizations.settingsTitle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startTrainingMode(BuildContext context) async {
    final trainingModeService = Provider.of<TrainingModeService>(context, listen: false);
    await trainingModeService.initialize();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainingModePage(),
        ),
      );
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