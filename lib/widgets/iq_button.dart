import 'package:flutter/material.dart';

class IQButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  const IQButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).elevatedButtonTheme.style;
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: style,
      child:
          loading
              ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
