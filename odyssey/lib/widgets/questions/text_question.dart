import 'package:flutter/material.dart';
import 'package:odyssey/models/questions/text_question_model.dart';
import 'package:odyssey/widgets/questions/next_button.dart';

class TextQuestion extends StatefulWidget {
  final TextQuestionModel model;
  final void Function(String) onSubmit;

  const TextQuestion({
    super.key,
    required this.model,
    required this.onSubmit,
  });

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.model.question,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            overflow: TextOverflow.ellipsis
          ),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.model.placeholder,
          ),
        ),
        SizedBox(height: 12.0),
        NextButton(
          onPressed: () {
            widget.onSubmit(_controller.text);
          },
        ),
      ],
    );
  }
}
