// lib/screens/meeting/meeting_screen.dart - FULL FEATURED UI
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../services/meeting_service.dart';
import 'widgets/index.dart';

@RoutePage()
class MeetingScreen extends StatefulWidget {
  final String code;

  const MeetingScreen({
    Key? key,
    @PathParam('code') required this.code,
  }) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late GcbMeetingService meetingService;
  bool _isJoining = true;
  String _errorMessage = '';

  // Panel visibility states
  bool _showParticipants = false;
  bool _showChat = false;
  bool _showLanguagePanel = false;

  @override
  void initState() {
    super.initState();
    meetingService = Provider.of<GcbMeetingService>(context, listen: false);
    _joinMeeting();
  }

  void _joinMeeting() async {
    try {
      setState(() {
        _isJoining = true;
        _errorMessage = '';
      });

      // Set user details (you might get this from auth or shared preferences)
      meetingService.setUserDetails(
        displayName: 'User ${DateTime.now().millisecond}',
      );

      // Join the meeting using the code
      await meetingService.joinMeeting(meetingId: widget.code);

      setState(() {
        _isJoining = false;
      });
    } catch (e) {
      setState(() {
        _isJoining = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join meeting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _leaveMeeting() async {
    try {
      await meetingService.leaveMeetingAsParticipant();
      if (mounted) {
        context.router.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error leaving meeting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isJoining
          ? _buildJoiningScreen()
          : _errorMessage.isNotEmpty
          ? _buildErrorScreen()
          : _buildMeetingScreen(),
    );
  }

  Widget _buildJoiningScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade700,
            Colors.blue.shade500,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Joining Meeting...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Meeting ID: ${widget.code}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.shade900,
            Colors.red.shade700,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to Join Meeting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _joinMeeting,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade700,
                          ),
                          child: const Text('Try Again'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => context.router.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingScreen() {
    return Consumer<GcbMeetingService>(
      builder: (context, service, child) {
        return Stack(
          children: [
            // Main meeting interface
            Column(
              children: [
                // Header bar
                _buildHeaderBar(service),

                // Main content area
                Expanded(
                  child: Row(
                    children: [
                      // Main video area
                      Expanded(
                        flex: 3,
                        child: _buildVideoArea(service),
                      ),

                      // Side panels (participants/chat/language)
                      if (_showParticipants || _showChat || _showLanguagePanel)
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey.shade700,
                                width: 1,
                              ),
                            ),
                          ),
                          child: _buildSidePanel(service),
                        ),
                    ],
                  ),
                ),

                // Bottom control bar
                _buildControlBar(service),
              ],
            ),

            // Floating subtitles
            if (service.subtitles.isNotEmpty)
              _buildFloatingSubtitles(service),
          ],
        );
      },
    );
  }

  Widget _buildHeaderBar(GcbMeetingService service) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.router.pop(),
          ),

          const SizedBox(width: 8),

          // Meeting info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meeting ID: ${widget.code}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Duration: ${service.formattedElapsedTime} • ${service.participantCount} participants',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Language indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${service.sourceLanguage.toUpperCase()} → ${service.targetLanguage.toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea(GcbMeetingService service) {
    final participants = service.participants;

    if (participants.isEmpty) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: Colors.white54,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Waiting for participants...',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Grid layout for multiple participants
    return Container(
      padding: const EdgeInsets.all(8),
      child: _buildVideoGrid(service, participants),
    );
  }

  Widget _buildVideoGrid(GcbMeetingService service, List<ParticipantModel> participants) {
    if (participants.length == 1) {
      // Single participant - full screen
      return _buildParticipantVideo(service, participants.first);
    } else if (participants.length <= 4) {
      // 2-4 participants - 2x2 grid
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return _buildParticipantVideo(service, participants[index]);
        },
      );
    } else {
      // More than 4 participants - scrollable grid
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return _buildParticipantVideo(service, participants[index]);
        },
      );
    }
  }

  Widget _buildParticipantVideo(GcbMeetingService service, ParticipantModel participant) {
    final renderer = service.getRendererForParticipant(participant.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
        border: participant.isSpeaking
            ? Border.all(color: Colors.green, width: 3)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Video or avatar
            if (renderer != null)
              RTCVideoView(renderer)
            else
              Container(
                color: Colors.grey.shade700,
                child: Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: participant.isHost ? Colors.amber : Colors.blue,
                    backgroundImage: participant.avatarUrl != null
                        ? NetworkImage(participant.avatarUrl!)
                        : null,
                    child: participant.avatarUrl == null
                        ? Text(
                      participant.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                        : null,
                  ),
                ),
              ),

            // Participant info overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        participant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (participant.isMuted)
                      const Icon(
                        Icons.mic_off,
                        color: Colors.red,
                        size: 14,
                      ),
                    if (participant.isHandRaised)
                      const Icon(
                        Icons.pan_tool,
                        color: Colors.orange,
                        size: 14,
                      ),
                    if (participant.isHost)
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel(GcbMeetingService service) {
    if (_showParticipants) {
      return ParticipantsPanel(
        participants: service.participants,
        onClose: () => setState(() => _showParticipants = false),
      );
    } else if (_showChat) {
      return ChatPanel(
        messages: service.messages,
        onSendMessage: service.sendMessage,
        onClose: () => setState(() => _showChat = false),
      );
    } else if (_showLanguagePanel) {
      return LanguageSelectionPanel(
        sourceLanguage: service.sourceLanguage,
        targetLanguage: service.targetLanguage,
        availableLanguages: service.languages,
        onSourceLanguageChanged: service.setSourceLanguage,
        onTargetLanguageChanged: service.setTargetLanguage,
        onClose: () => setState(() => _showLanguagePanel = false),
      );
    }

    return Container();
  }

  Widget _buildControlBar(GcbMeetingService service) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Microphone
          _buildControlButton(
            icon: service.isMicrophoneEnabled ? Icons.mic : Icons.mic_off,
            label: 'Mic',
            isActive: service.isMicrophoneEnabled,
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
            onPressed: service.toggleMicrophone,
          ),

          // Camera
          _buildControlButton(
            icon: service.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
            label: 'Camera',
            isActive: service.isCameraEnabled,
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
            onPressed: service.toggleCamera,
          ),

          // Screen share
          _buildControlButton(
            icon: Icons.screen_share,
            label: 'Share',
            isActive: service.isScreenSharing,
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
            onPressed: service.toggleScreenSharing,
          ),

          // Speech recognition
          _buildControlButton(
            icon: service.isListening ? Icons.mic : Icons.mic_none,
            label: 'Speech',
            isActive: service.isListening,
            activeColor: Colors.purple,
            inactiveColor: Colors.grey,
            onPressed: service.toggleSpeechRecognition,
          ),

          // Hand raise
          _buildControlButton(
            icon: Icons.pan_tool,
            label: 'Hand',
            isActive: false, // TODO: Get from current user participant
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            onPressed: service.toggleHandRaised,
          ),

          // Participants
          _buildControlButton(
            icon: Icons.people,
            label: 'Participants',
            isActive: _showParticipants,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onPressed: () => setState(() {
              _showParticipants = !_showParticipants;
              _showChat = false;
              _showLanguagePanel = false;
            }),
          ),

          // Chat
          _buildControlButton(
            icon: Icons.chat,
            label: 'Chat',
            isActive: _showChat,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onPressed: () => setState(() {
              _showChat = !_showChat;
              _showParticipants = false;
              _showLanguagePanel = false;
            }),
            badge: service.messages.isNotEmpty ? service.messages.length : null,
          ),

          // Language
          _buildControlButton(
            icon: Icons.translate,
            label: 'Lang',
            isActive: _showLanguagePanel,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onPressed: () => setState(() {
              _showLanguagePanel = !_showLanguagePanel;
              _showParticipants = false;
              _showChat = false;
            }),
          ),

          // Leave call
          _buildControlButton(
            icon: Icons.call_end,
            label: 'Leave',
            isActive: false,
            activeColor: Colors.red,
            inactiveColor: Colors.red,
            onPressed: _leaveMeeting,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onPressed,
    int? badge,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: Icon(icon, color: Colors.white),
                onPressed: onPressed,
              ),
            ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingSubtitles(GcbMeetingService service) {
    if (service.subtitles.isEmpty) return Container();

    final latestSubtitle = service.subtitles.first;

    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          latestSubtitle.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}