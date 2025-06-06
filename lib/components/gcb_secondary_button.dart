import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GcbSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  
  const GcbSecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidget = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: GcbAppTheme.primary,
        side: const BorderSide(color: GcbAppTheme.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: GcbAppTheme.primary,
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: GcbAppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    return isLoading
        ? buttonWidget
        : buttonWidget
            .animate()
            .scale(
              duration: const Duration(milliseconds: 100),
              begin: const Offset(1, 1),
              end: const Offset(0.97, 0.97),
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              duration: const Duration(milliseconds: 100),
              begin: const Offset(0.97, 0.97),
              end: const Offset(1, 1),
              curve: Curves.easeInOut,
            );
  }
}