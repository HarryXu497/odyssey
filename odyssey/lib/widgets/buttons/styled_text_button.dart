import 'package:flutter/material.dart';
import 'package:odyssey/widgets/buttons/styled_button.dart';

class StyledTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const StyledTextButton(
    this.text, {
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StyledButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
