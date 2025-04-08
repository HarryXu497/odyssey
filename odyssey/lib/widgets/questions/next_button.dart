import 'package:flutter/material.dart';
import 'package:odyssey/widgets/buttons/styled_text_button.dart';

class NextButton extends StatelessWidget {
  final void Function() onPressed;
  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StyledTextButton("Proceed", onPressed: onPressed);
  }
}
