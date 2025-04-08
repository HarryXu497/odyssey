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
    return IntrinsicWidth(
      child: Column(
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
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: widget.model.placeholder,
              hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
              fillColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: NextButton(
              onPressed: () {
                widget.onSubmit(_controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
