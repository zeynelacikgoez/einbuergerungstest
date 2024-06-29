import 'package:flutter/material.dart';
import '../models/question_model.dart';

class OverviewPage extends StatelessWidget {
  final List<QuestionModel> questions;
  final List<bool?> answerResults;
  final Function(int) onQuestionSelected;
  final VoidCallback onRestart;
  final bool isCompleted;

  const OverviewPage({
    Key? key,
    required this.questions,
    required this.answerResults,
    required this.onQuestionSelected,
    required this.onRestart,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isCompleted) {
          return await _showExitConfirmationDialog(context) ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Übersicht'),
          automaticallyImplyLeading: !isCompleted,
          leading: isCompleted
              ? IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => _showExitConfirmationDialog(context),
                )
              : null,
          actions: [
            if (isCompleted)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _showRestartConfirmationDialog(context),
              ),
          ],
        ),
        body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            QuestionModel question = questions[index];
            bool? isCorrect = answerResults[index];

            return ListTile(
              title: Text('Frage ${index + 1}'),
              subtitle: Text('${question.part} - ${question.section}'),
              trailing: isCorrect == null
                  ? const Icon(Icons.help_outline, color: Colors.grey)
                  : Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
              onTap: isCompleted ? null : () => onQuestionSelected(index),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zum Hauptmenü'),
        content: const Text('Möchten Sie wirklich zum Hauptmenü zurückkehren?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Ja'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRestartConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test neustarten'),
        content: const Text('Möchten Sie den Test wirklich neu starten?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRestart();
            },
            child: const Text('Ja'),
          ),
        ],
      ),
    );
  }
}