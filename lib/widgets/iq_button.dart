import 'package:flutter/material.dart';

class IQButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon; // Optionnel

  const IQButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: loading ? 0.8 : 1.0,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(14),
        splashColor: btnColor.withOpacity(0.2),
        child: Ink(
          decoration: BoxDecoration(
            color: loading ? btnColor.withOpacity(0.6) : btnColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (!loading)
                BoxShadow(
                  color: btnColor.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                loading
                    ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: textColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
