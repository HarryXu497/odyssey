import 'package:flutter/material.dart';
import 'package:odyssey/models/questions/text_question_model.dart';
import 'package:odyssey/screens/screen_with_navigation.dart';
import 'package:odyssey/widgets/questions/text_question.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWithNavigation(
      startingIndex: 0,
      appBar: AppBar(
        title: Text(
          "ADD ITEM",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: TextQuestion(
          model: TextQuestionModel(
            question: "what do you want to add?",
            placeholder: "shirt, pants, laptop, etc",
          ),
          onSubmit: (value) {
            if (value.isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
        ),
      ),
    );
  }
}
