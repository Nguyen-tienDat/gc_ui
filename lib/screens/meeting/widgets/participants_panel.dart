// lib/screens/meeting/widgets/participants_panel.dart
import 'package:flutter/material.dart';
import '../../../services/meeting_service.dart';

class ParticipantsPanel extends StatefulWidget {
  final List<ParticipantModel> participants;
  final VoidCallback onClose;

  const ParticipantsPanel({
    Key? key,
    required this.participants,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ParticipantsPanel> createState() => _ParticipantsPanelState();
}

class _ParticipantsPanelState extends State<ParticipantsPanel> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredParticipants = widget.participants.where((participant) {
      return participant.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(
          left: BorderSide(color: Colors.grey.shade700, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade700, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Participants (${widget.participants.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search participants...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Participants list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: filteredParticipants.length,
              itemBuilder: (context, index) {
                final participant = filteredParticipants[index];
                return _buildParticipantTile(participant);
              },
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              border: Border(
                top: BorderSide(color: Colors.grey.shade700, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Invite button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showInviteDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Invite Others'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Meeting info
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.grey.shade400, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Meeting started ${_getTimeAgo()}',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile(ParticipantModel participant) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: participant.isSpeaking
            ? Colors.green.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: participant.isSpeaking
            ? Border.all(color: Colors.green.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: participant.isHost ? Colors.amber : Colors.blue,
              backgroundImage: participant.avatarUrl != null
                  ? NetworkImage(participant.avatarUrl!)
                  : null,
              child: participant.avatarUrl == null
                  ? Text(
                participant.name.isNotEmpty
                    ? participant.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
            if (participant.isSpeaking)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                participant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (participant.isHost)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'HOST',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              '${participant.speakingLanguage} → ${participant.listeningLanguage}',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (participant.isMuted)
              Icon(
                Icons.mic_off,
                color: Colors.red.shade400,
                size: 16,
              ),
            if (participant.isHandRaised) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.pan_tool,
                color: Colors.orange.shade400,
                size: 16,
              ),
            ],
            if (participant.isScreenSharing) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.screen_share,
                color: Colors.green.shade400,
                size: 16,
              ),
            ],
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey.shade400, size: 16),
              color: Colors.grey.shade800,
              onSelected: (value) => _handleParticipantAction(participant, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'message',
                  child: Row(
                    children: [
                      Icon(Icons.message, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text('Send Message', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                if (participant.isHost)
                  const PopupMenuItem(
                    value: 'promote',
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.amber, size: 16),
                        SizedBox(width: 8),
                        Text('Promote to Host', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleParticipantAction(ParticipantModel participant, String action) {
    switch (action) {
      case 'message':
      // TODO: Open private message to participant
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Send message to ${participant.name}')),
        );
        break;
      case 'promote':
      // TODO: Promote participant to host
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Promote ${participant.name} to host')),
        );
        break;
      case 'remove':
      // TODO: Remove participant from meeting
        _showRemoveConfirmation(participant);
        break;
    }
  }

  void _showRemoveConfirmation(ParticipantModel participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          'Remove Participant',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove ${participant.name} from the meeting?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement remove participant
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${participant.name} removed from meeting')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          'Invite Others',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share this meeting ID with others:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Meeting ID: GCM-EXAMPLE',  // TODO: Get real meeting ID
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () {
                      // TODO: Copy to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meeting ID copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Share meeting link
            },
            child: const Text('Share Link'),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo() {
    // TODO: Calculate actual time from meeting start
    return 'a few minutes ago';
  }
}