import 'package:flutter/material.dart';

class IQLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const IQLinkButton({Key? key, required this.label, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
