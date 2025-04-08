import 'package:flutter/material.dart';
import 'package:odyssey/models/questions/location_question_model.dart';
import 'package:odyssey/models/questions/question_model.dart';
import 'package:odyssey/models/questions/text_question_model.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:odyssey/widgets/questions/location_question.dart';
import 'package:odyssey/widgets/questions/text_question.dart';

class QuestionsScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  final void Function(List<dynamic>) onDone;

  const QuestionsScreen({
    super.key,
    required this.questions,
    required this.onDone,
  });

  @override
  State<QuestionsScreen> createState() =>
      _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentIndex = 0;

  List<dynamic> values = [];

  void _addItem(dynamic value) {
    values.add(value);

    setState(() {
      if (_currentIndex >= widget.questions.length - 1) {
        widget.onDone(values);
      } else {
        _currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentModel = widget.questions[_currentIndex];

    Widget currentWidget = Placeholder();

    if (currentModel is TextQuestionModel) {
      currentWidget = TextQuestion(
        model: currentModel,
        onSubmit: _addItem,
      );
    }

    if (currentModel is LocationQuestionModel) {
      currentWidget = LocationQuestion(
        model: currentModel,
        onSubmit: _addItem,
      );
    }

    return ScreenWithNavigation(
      appBar: AppBar(
        title: Text(
          "NEW TRIP",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(child: currentWidget),
    );
  }
}
