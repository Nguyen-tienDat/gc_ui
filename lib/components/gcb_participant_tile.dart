import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/participant_model.dart';
import '../theme/app_theme.dart';

class GcbParticipantTile extends StatelessWidget {
  final GcbParticipantModel participant;
  final bool isScreenSharing;
  final bool isLarge;
  
  const GcbParticipantTile({
    Key? key,
    required this.participant,
    this.isScreenSharing = false,
    this.isLarge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GcbAppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: participant.isSpeaking
            ? Border.all(color: GcbAppTheme.speaking, width: 2)
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video or avatar placeholder
          if (participant.isVideoOn && !isScreenSharing)
            // In a real app, this would be a video widget
            Image.network(
              participant.avatarUrl ?? 'https://randomuser.me/api/portraits/lego/1.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
            )
          else if (isScreenSharing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Icon(
                  PhosphorIconsRegular.monitorPlay,
                  size: isLarge ? 64 : 32,
                  color: Colors.white70,
                ),
              ),
            )
          else
            _buildAvatarPlaceholder(),
          
          // Participant info overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      participant.name + (participant.isHost ? ' (Host)' : ''),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (participant.isMuted)
                    const Icon(
                      PhosphorIconsFill.microphone,
                      color: GcbAppTheme.muted,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
          
          // Hand raised indicator
          if (participant.isHandRaised)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: GcbAppTheme.warning,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  PhosphorIconsFill.hand,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildAvatarPlaceholder() {
    return Container(
      color: GcbAppTheme.surfaceLight,
      child: Center(
        child: CircleAvatar(
          radius: isLarge ? 40 : 24,
          backgroundColor: GcbAppTheme.surface,
          backgroundImage: participant.avatarUrl != null
              ? NetworkImage(participant.avatarUrl!)
              : null,
          child: participant.avatarUrl == null
              ? Text(
                  participant.name.isNotEmpty ? participant.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: isLarge ? 32 : 20,
                    fontWeight: FontWeight.bold,
                    color: GcbAppTheme.textPrimary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}