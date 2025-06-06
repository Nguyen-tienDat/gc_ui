// lib/screens/meeting/controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/meeting_service.dart';

class MeetingController extends ChangeNotifier {
  final BuildContext context;
  late final GcbMeetingService _meetingService;

  // Panel visibility states
  bool _showParticipants = false;
  bool _showChat = false;
  bool _showLanguagePanel = false;

  // Meeting states
  bool _isJoining = true;
  String _errorMessage = '';

  // UI states
  bool _isControlBarVisible = true;
  bool _isFullScreen = false;

  MeetingController(this.context) {
    _meetingService = Provider.of<GcbMeetingService>(context, listen: false);
  }

  // Getters
  GcbMeetingService get meetingService => _meetingService;
  bool get showParticipants => _showParticipants;
  bool get showChat => _showChat;
  bool get showLanguagePanel => _showLanguagePanel;
  bool get isJoining => _isJoining;
  String get errorMessage => _errorMessage;
  bool get isControlBarVisible => _isControlBarVisible;
  bool get isFullScreen => _isFullScreen;

  // Panel controls
  void toggleParticipants() {
    _showParticipants = !_showParticipants;
    _showChat = false;
    _showLanguagePanel = false;
    notifyListeners();
  }

  void toggleChat() {
    _showChat = !_showChat;
    _showParticipants = false;
    _showLanguagePanel = false;
    notifyListeners();
  }

  void toggleLanguagePanel() {
    _showLanguagePanel = !_showLanguagePanel;
    _showParticipants = false;
    _showChat = false;
    notifyListeners();
  }

  void closeAllPanels() {
    _showParticipants = false;
    _showChat = false;
    _showLanguagePanel = false;
    notifyListeners();
  }

  // UI controls
  void toggleControlBar() {
    _isControlBarVisible = !_isControlBarVisible;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  // Meeting controls
  Future<void> joinMeeting(String meetingId) async {
    try {
      _isJoining = true;
      _errorMessage = '';
      notifyListeners();

      // Set user details (you might get this from auth or shared preferences)
      _meetingService.setUserDetails(
        displayName: 'User ${DateTime.now().millisecond}',
      );

      // Join the meeting using the code
      await _meetingService.joinMeeting(meetingId: meetingId);

      _isJoining = false;
      notifyListeners();
    } catch (e) {
      _isJoining = false;
      _errorMessage = e.toString();
      notifyListeners();

      _showError('Failed to join meeting: $e');
    }
  }

  Future<void> leaveMeeting() async {
    try {
      await _meetingService.leaveMeetingAsParticipant();
      // Navigation will be handled by the calling widget
    } catch (e) {
      _showError('Error leaving meeting: $e');
    }
  }

  // Media controls
  Future<void> toggleMicrophone() async {
    try {
      await _meetingService.toggleMicrophone();
    } catch (e) {
      _showError('Error toggling microphone: $e');
    }
  }

  Future<void> toggleCamera() async {
    try {
      await _meetingService.toggleCamera();
    } catch (e) {
      _showError('Error toggling camera: $e');
    }
  }

  Future<void> toggleScreenSharing() async {
    try {
      await _meetingService.toggleScreenSharing();
    } catch (e) {
      _showError('Error toggling screen sharing: $e');
    }
  }

  Future<void> toggleSpeechRecognition() async {
    try {
      await _meetingService.toggleSpeechRecognition();
    } catch (e) {
      _showError('Error toggling speech recognition: $e');
    }
  }

  Future<void> toggleHandRaised() async {
    try {
      await _meetingService.toggleHandRaised();
    } catch (e) {
      _showError('Error toggling hand raised: $e');
    }
  }

  // Chat controls
  Future<void> sendMessage(String message) async {
    try {
      await _meetingService.sendMessage(message);
    } catch (e) {
      _showError('Error sending message: $e');
    }
  }

  // Language controls
  void setSourceLanguage(String language) {
    _meetingService.setSourceLanguage(language);
  }

  void setTargetLanguage(String language) {
    _meetingService.setTargetLanguage(language);
  }

  // Helper methods
  void _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showSuccess(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Debug helpers
  void debugState() {
    print('=== MEETING CONTROLLER DEBUG ===');
    print('Show Participants: $_showParticipants');
    print('Show Chat: $_showChat');
    print('Show Language Panel: $_showLanguagePanel');
    print('Is Joining: $_isJoining');
    print('Error Message: $_errorMessage');
    print('Control Bar Visible: $_isControlBarVisible');
    print('Full Screen: $_isFullScreen');
    print('================================');

    // Also debug the meeting service
    _meetingService.debugStates();
  }

  // Keyboard shortcuts
  void handleKeyboardShortcut(String shortcut) {
    switch (shortcut) {
      case 'toggle_mic':
        toggleMicrophone();
        break;
      case 'toggle_camera':
        toggleCamera();
        break;
      case 'toggle_chat':
        toggleChat();
        break;
      case 'toggle_participants':
        toggleParticipants();
        break;
      case 'leave_meeting':
        leaveMeeting();
        break;
      case 'toggle_fullscreen':
        toggleFullScreen();
        break;
      default:
        print('Unknown keyboard shortcut: $shortcut');
    }
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }
}