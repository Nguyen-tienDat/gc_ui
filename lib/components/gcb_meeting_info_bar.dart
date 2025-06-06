import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/app_theme.dart';

class GcbMeetingInfoBar extends StatelessWidget {
  final String meetingCode;
  final bool isRecording;
  final Duration elapsedTime;
  final VoidCallback onCopyCode;
  
  const GcbMeetingInfoBar({
    Key? key,
    required this.meetingCode,
    required this.isRecording,
    required this.elapsedTime,
    required this.onCopyCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedTime = _formatDuration(elapsedTime);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: GcbAppTheme.surface,
      ),
      child: Row(
        children: [
          // Meeting duration
          Icon(
            PhosphorIconsLight.clock,
            size: 16,
            color: GcbAppTheme.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            formattedTime,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: GcbAppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          
          // Recording indicator
          if (isRecording) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: GcbAppTheme.recording.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIconsFill.record,
                    size: 12,
                    color: GcbAppTheme.recording,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'REC',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: GcbAppTheme.recording,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Meeting code
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIconsLight.handTap,
                  size: 16,
                  color: GcbAppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  meetingCode,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: GcbAppTheme.textSecondary,
                  ),
                ),
                IconButton(
                  onPressed: onCopyCode,
                  icon: Icon(
                    PhosphorIconsLight.copy,
                    size: 16,
                    color: GcbAppTheme.primary,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Participants count - right side
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: GcbAppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIconsLight.users,
                  size: 14,
                  color: GcbAppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '5',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GcbAppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}