import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final bool showFeedback;
  final bool? isLastAnswerCorrect;
  final Function(bool) onAnswerSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    this.showFeedback = false,
    this.isLastAnswerCorrect,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${question.part} - ${question.section}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              question.task,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              question.question['text'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (question.question['imageReference'] != 'none')
              Image.asset('assets/image/${question.question['imageReference']}'),
            const SizedBox(height: 24),
            ...question.options.map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: showFeedback && option['isCorrect']
                        ? Colors.green
                        : (showFeedback && !option['isCorrect'] && isLastAnswerCorrect == false)
                            ? Colors.red
                            : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text(
                    option['text'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: showFeedback ? Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: showFeedback ? null : () => onAnswerSelected(option['isCorrect']),
                ),
              );
            }),
            if (showFeedback)
              Text(
                isLastAnswerCorrect! ? 'Richtig!' : 'Falsch!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isLastAnswerCorrect! ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}