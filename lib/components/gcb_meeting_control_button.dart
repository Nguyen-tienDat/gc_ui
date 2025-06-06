import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GcbMeetingControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isHighlighted;
  final Color? activeColor;
  final Color? inactiveColor;
  
  const GcbMeetingControlButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = true,
    this.isHighlighted = false,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isActive 
        ? (activeColor ?? GcbAppTheme.surfaceLight)
        : (inactiveColor ?? GcbAppTheme.error.withOpacity(0.2));
    
    final Color iconColor = isActive 
        ? GcbAppTheme.textPrimary
        : (inactiveColor ?? GcbAppTheme.error);

    final buttonWidget = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: isHighlighted
                    ? Border.all(color: GcbAppTheme.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isActive ? GcbAppTheme.textSecondary : iconColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return buttonWidget
        .animate()
        .scale(
          duration: const Duration(milliseconds: 100),
          begin: const Offset(1, 1),
          end: const Offset(0.95, 0.95),
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          duration: const Duration(milliseconds: 100),
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeInOut,
        );
  }
}