import 'package:flutter/material.dart';

import '../models/subtitle_model.dart';
import '../theme/app_theme.dart';

class GcbSubtitleDisplay extends StatelessWidget {
  final List<GcbSubtitleModel> subtitles;
  final String selectedLanguage;
  
  const GcbSubtitleDisplay({
    Key? key,
    required this.subtitles,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter subtitles by selected language
    final filteredSubtitles = subtitles
        .where((subtitle) => subtitle.language == selectedLanguage)
        .toList();
    
    // Sort by timestamp (newest first)
    filteredSubtitles.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Show only the most recent subtitle
    final latestSubtitle = filteredSubtitles.isNotEmpty ? filteredSubtitles.first : null;
    
    if (latestSubtitle == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            latestSubtitle.participantName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: GcbAppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            latestSubtitle.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}