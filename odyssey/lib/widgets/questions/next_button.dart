import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final void Function() onPressed;
  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
        foregroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      child: Text(
        "Proceed",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
