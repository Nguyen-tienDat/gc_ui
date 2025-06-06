// lib/services/webrtc_meeting_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

// Abstract base class to match existing UI
abstract class GcbMeetingService extends ChangeNotifier {
  // Abstract properties and methods that UI expects
  String? get meetingId;
  String? get userId;
  bool get isHost;
  bool get isMeetingActive;
  bool get isListening;
  Duration get elapsedTime;
  String get speakingLanguage;
  String get listeningLanguage;
  List<ParticipantModel> get participants;
  List<SubtitleModel> get subtitles;
  List<ChatMessage> get messages;
  RTCVideoRenderer? get localRenderer;

  // Abstract methods
  Future<void> initialize();
  Future<String> createMeeting({required String topic, String? password, List<String> translationLanguages = const []});
  Future<void> joinMeeting({required String meetingId, String? password});
  Future<void> toggleMicrophone();
  Future<void> toggleCamera();
  Future<void> toggleScreenSharing();
  Future<void> toggleHandRaised();
  Future<void> endMeetingForAll();
  Future<void> leaveMeetingAsParticipant();
  Future<void> toggleSpeechRecognition();
  Future<void> startSpeechRecognition();
  Future<void> stopSpeechRecognition();
  Future<void> sendMessage(String message);
  RTCVideoRenderer? getRendererForParticipant(String participantId);
  void setUserDetails({required String displayName, String? userId});
  void setLanguagePreferences({required String speaking, required String listening});
}

// WebRTC implementation using Metered SFU
class WebRTCMeetingService extends GcbMeetingService {
  // Metered SFU Configuration
  static const String _sfuHost = "https://global.sfu.metered.ca";
  static const String _sfuAppId = "684272d83a97f8dcea82abea";
  static const String _sfuSecret = "XsMrnmK6kLFO/rlA";
  static const String _stunServer = "stun:stun.metered.ca:80";

  // WebRTC Components
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer? _localRenderer;
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, MediaStream> _remoteStreams = {};

  // Meeting State
  String? _sessionId;
  String? _meetingId;
  String? _userId;
  String _displayName = 'User';
  bool _isHost = false;
  bool _isMeetingActive = false;
  bool _isConnected = false;

  // Audio/Video State
  bool _isMicrophoneMuted = false;
  bool _isCameraEnabled = true;
  bool _isScreenSharing = false;
  bool _isHandRaised = false;

  // Meeting Timer
  Timer? _elapsedTimer;
  DateTime? _meetingStartTime;

  // Dummy data for UI
  final List<ParticipantModel> _participants = [];
  final List<SubtitleModel> _subtitles = [];
  final List<ChatMessage> _messages = [];
  String _speakingLanguage = 'english';
  String _listeningLanguage = 'english';

  @override
  String? get meetingId => _meetingId;

  @override
  String? get userId => _userId;

  @override
  bool get isHost => _isHost;

  @override
  bool get isMeetingActive => _isMeetingActive;

  @override
  bool get isListening => false; // Not implementing speech recognition

  @override
  Duration get elapsedTime {
    if (_meetingStartTime == null) return Duration.zero;
    return DateTime.now().difference(_meetingStartTime!);
  }

  @override
  String get speakingLanguage => _speakingLanguage;

  @override
  String get listeningLanguage => _listeningLanguage;

  @override
  List<ParticipantModel> get participants => List.unmodifiable(_participants);

  @override
  List<SubtitleModel> get subtitles => List.unmodifiable(_subtitles);

  @override
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  @override
  RTCVideoRenderer? get localRenderer => _localRenderer;

  @override
  Future<void> initialize() async {
    print('Initializing WebRTC Meeting Service...');

    // Generate user ID
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

    // Request permissions
    await _requestPermissions();

    // Initialize renderers
    await _initializeRenderers();

    print('WebRTC Meeting Service initialized with userId: $_userId');
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
    ];

    for (final permission in permissions) {
      final status = await permission.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Permission $permission not granted');
      }
    }
  }

  Future<void> _initializeRenderers() async {
    _localRenderer = RTCVideoRenderer();
    await _localRenderer!.initialize();
  }

  @override
  void setUserDetails({required String displayName, String? userId}) {
    _displayName = displayName;
    if (userId != null) _userId = userId;
    print('User details set: $_displayName ($_userId)');
  }

  @override
  void setLanguagePreferences({required String speaking, required String listening}) {
    _speakingLanguage = speaking;
    _listeningLanguage = listening;
    print('Language preferences set: speaking=$speaking, listening=$listening');
  }

  @override
  Future<String> createMeeting({
    required String topic,
    String? password,
    List<String> translationLanguages = const [],
  }) async {
    try {
      print('Creating meeting: $topic');

      // Generate meeting ID
      final meetingId = 'GCM-${DateTime.now().millisecondsSinceEpoch}';
      _meetingId = meetingId;
      _isHost = true;

      // Initialize local media
      await _initializeLocalMedia();

      // Create peer connection
      await _createPeerConnection();

      // Add local tracks to peer connection
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
        }
      }

      // Create SFU session
      await _createSfuSession();

      // Start meeting
      _startMeeting();

      print('Meeting created successfully: $meetingId');
      return meetingId;

    } catch (e) {
      print('Error creating meeting: $e');
      throw Exception('Failed to create meeting: $e');
    }
  }

  @override
  Future<void> joinMeeting({required String meetingId, String? password}) async {
    try {
      print('Joining meeting: $meetingId');

      _meetingId = meetingId;
      _isHost = false;

      // Initialize local media
      await _initializeLocalMedia();

      // Create peer connection
      await _createPeerConnection();

      // Add local tracks to peer connection
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
        }
      }

      // Create SFU session
      await _createSfuSession();

      // Start meeting
      _startMeeting();

      // Subscribe to existing tracks (simulate joining existing meeting)
      await _subscribeToExistingTracks();

      print('Successfully joined meeting: $meetingId');

    } catch (e) {
      print('Error joining meeting: $e');
      throw Exception('Failed to join meeting: $e');
    }
  }

  Future<void> _initializeLocalMedia() async {
    try {
      print('Initializing local media...');

      final constraints = {
        'audio': true,
        'video': {
          'width': 1280,
          'height': 720,
          'frameRate': 30,
        }
      };

      _localStream = await navigator.mediaDevices.getUserMedia(constraints);

      if (_localRenderer != null) {
        _localRenderer!.srcObject = _localStream;
      }

      print('Local media initialized successfully');

    } catch (e) {
      print('Error initializing local media: $e');
      throw Exception('Failed to initialize camera/microphone: $e');
    }
  }

  Future<void> _createPeerConnection() async {
    try {
      print('Creating peer connection...');

      final config = {
        'iceServers': [
          {'urls': _stunServer}
        ],
        'sdpSemantics': 'unified-plan',
      };

      _peerConnection = await createPeerConnection(config);

      // Handle ICE connection state changes
      _peerConnection!.onIceConnectionState = (state) {
        print('ICE Connection State: $state');

        if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
          _isConnected = true;
          print('WebRTC connection established successfully');
          notifyListeners();
        } else if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
            state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          _isConnected = false;
          print('WebRTC connection lost');
          notifyListeners();
        }
      };

      // Handle remote tracks
      _peerConnection!.onTrack = (event) {
        print('Received remote track: ${event.track.kind}');
        _handleRemoteTrack(event);
      };

      print('Peer connection created successfully');

    } catch (e) {
      print('Error creating peer connection: $e');
      throw e;
    }
  }

  Future<void> _createSfuSession() async {
    try {
      print('Creating SFU session...');

      // Create offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      // Send offer to SFU
      final response = await http.post(
        Uri.parse('$_sfuHost/api/sfu/$_sfuAppId/session/new'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_sfuSecret',
        },
        body: jsonEncode({
          'sessionDescription': offer.toMap(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _sessionId = data['sessionId'];

        final remoteSdp = RTCSessionDescription(
          data['sessionDescription']['sdp'],
          data['sessionDescription']['type'],
        );

        await _peerConnection!.setRemoteDescription(remoteSdp);

        _isConnected = true;
        print('SFU session created successfully: $_sessionId');

      } else {
        throw Exception('Failed to create SFU session: ${response.statusCode} - ${response.body}');
      }

    } catch (e) {
      print('Error creating SFU session: $e');
      throw e;
    }
  }

  Future<void> _subscribeToExistingTracks() async {
    try {
      print('Subscribing to existing tracks...');

      if (_sessionId == null) {
        print('No session ID available for subscribing to tracks');
        return;
      }

      // Get the list of available tracks from SFU
      final response = await http.get(
        Uri.parse('$_sfuHost/api/sfu/$_sfuAppId/session/$_sessionId/tracks'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_sfuSecret',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Available tracks: $data');

        // For demo purposes, we'll simulate some existing participants
        _simulateDemoParticipants();

      } else {
        print('Failed to get tracks: ${response.statusCode} - ${response.body}');
      }

    } catch (e) {
      print('Error subscribing to existing tracks: $e');
    }
  }

  void _simulateDemoParticipants() {
    print('Adding demo participants for testing...');

    // Add some demo participants
    final demoParticipants = [
      ParticipantModel(
        id: 'demo_user_1',
        name: 'Alice Johnson',
        isHost: false,
        isMuted: false,
        isSpeaking: true,
      ),
      ParticipantModel(
        id: 'demo_user_2',
        name: 'Bob Smith',
        isHost: false,
        isMuted: true,
        isSpeaking: false,
      ),
      ParticipantModel(
        id: 'demo_user_3',
        name: 'Carol Davis',
        isHost: false,
        isMuted: false,
        isSpeaking: false,
      ),
    ];

    _participants.addAll(demoParticipants);

    // Add some demo chat messages
    final demoMessages = [
      ChatMessage(
        id: 'msg_1',
        senderId: 'demo_user_1',
        senderName: 'Alice Johnson',
        text: 'Hello everyone! Welcome to the meeting.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'demo_user_2',
        senderName: 'Bob Smith',
        text: 'Thanks for organizing this!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isMe: false,
      ),
    ];

    _messages.addAll(demoMessages);

    print('Demo participants and messages added');
  }

  void _handleRemoteTrack(RTCTrackEvent event) async {
    final track = event.track;
    final streams = event.streams;

    if (streams.isNotEmpty) {
      final stream = streams.first;
      final streamId = stream.id;

      print('Handling remote ${track.kind} track from stream: $streamId');

      // Create renderer for remote video
      if (track.kind == 'video') {
        final renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = stream;
        _remoteRenderers[streamId] = renderer;
        print('Remote video renderer created for stream: $streamId');
      }

      _remoteStreams[streamId] = stream;
      notifyListeners();
    }
  }

  void _startMeeting() {
    _isMeetingActive = true;
    _meetingStartTime = DateTime.now();

    // Add local participant
    _addLocalParticipant();

    // Start elapsed timer
    _startElapsedTimer();

    print('Meeting started successfully');
    notifyListeners();
  }

  void _addLocalParticipant() {
    final localParticipant = ParticipantModel(
      id: _userId!,
      name: '$_displayName (You)',
      isHost: _isHost,
      isMuted: _isMicrophoneMuted,
      isSpeaking: false,
      isHandRaised: _isHandRaised,
      isScreenSharing: _isScreenSharing,
    );

    // Remove any existing local participant
    _participants.removeWhere((p) => p.id == _userId);

    // Add at the beginning
    _participants.insert(0, localParticipant);
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  @override
  Future<void> toggleMicrophone() async {
    try {
      if (_localStream != null) {
        final audioTracks = _localStream!.getAudioTracks();
        if (audioTracks.isNotEmpty) {
          final track = audioTracks.first;
          track.enabled = !track.enabled;
          _isMicrophoneMuted = !track.enabled;

          print('Microphone ${_isMicrophoneMuted ? 'muted' : 'unmuted'}');

          // Update local participant
          _updateLocalParticipant();
        }
      }
    } catch (e) {
      print('Error toggling microphone: $e');
    }
  }

  @override
  Future<void> toggleCamera() async {
    try {
      if (_localStream != null) {
        final videoTracks = _localStream!.getVideoTracks();
        if (videoTracks.isNotEmpty) {
          final track = videoTracks.first;
          track.enabled = !track.enabled;
          _isCameraEnabled = track.enabled;

          print('Camera ${_isCameraEnabled ? 'enabled' : 'disabled'}');
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error toggling camera: $e');
    }
  }

  @override
  Future<void> toggleScreenSharing() async {
    try {
      _isScreenSharing = !_isScreenSharing;
      print('Screen sharing ${_isScreenSharing ? 'started' : 'stopped'}');

      if (_isScreenSharing) {
        // In a real implementation, you would:
        // 1. Get display media stream
        // 2. Replace video track in peer connection
        // 3. Update UI to show screen share
        print('Screen sharing started (simulated)');
      } else {
        // In a real implementation, you would:
        // 1. Stop screen share stream
        // 2. Switch back to camera
        // 3. Update UI
        print('Screen sharing stopped (simulated)');
      }

      _updateLocalParticipant();
    } catch (e) {
      print('Error toggling screen sharing: $e');
    }
  }

  @override
  Future<void> toggleHandRaised() async {
    try {
      _isHandRaised = !_isHandRaised;
      print('Hand ${_isHandRaised ? 'raised' : 'lowered'}');

      _updateLocalParticipant();
    } catch (e) {
      print('Error toggling hand raised: $e');
    }
  }

  void _updateLocalParticipant() {
    final index = _participants.indexWhere((p) => p.id == _userId);
    if (index >= 0) {
      _participants[index] = ParticipantModel(
        id: _userId!,
        name: '$_displayName (You)',
        isHost: _isHost,
        isMuted: _isMicrophoneMuted,
        isSpeaking: false,
        isHandRaised: _isHandRaised,
        isScreenSharing: _isScreenSharing,
      );

      notifyListeners();
    }
  }

  @override
  Future<void> endMeetingForAll() async {
    print('Host ending meeting for all participants...');
    await _cleanup();
  }

  @override
  Future<void> leaveMeetingAsParticipant() async {
    print('Participant leaving meeting...');
    await _cleanup();
  }

  Future<void> _cleanup() async {
    try {
      print('Cleaning up meeting resources...');

      // Stop timer
      _elapsedTimer?.cancel();
      _elapsedTimer = null;
      _meetingStartTime = null;

      // Close peer connection
      if (_peerConnection != null) {
        await _peerConnection!.close();
        _peerConnection = null;
      }

      // Stop local stream
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          await track.stop();
        }
        _localStream = null;
      }

      // Dispose renderers
      if (_localRenderer != null) {
        await _localRenderer!.dispose();
        _localRenderer = null;
      }

      for (var renderer in _remoteRenderers.values) {
        await renderer.dispose();
      }
      _remoteRenderers.clear();
      _remoteStreams.clear();

      // Clear state
      _sessionId = null;
      _isConnected = false;
      _meetingId = null;
      _isHost = false;
      _isMeetingActive = false;
      _participants.clear();
      _subtitles.clear();
      _messages.clear();

      // Reset audio/video state
      _isMicrophoneMuted = false;
      _isCameraEnabled = true;
      _isScreenSharing = false;
      _isHandRaised = false;

      print('Cleanup completed successfully');
      notifyListeners();

    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  @override
  RTCVideoRenderer? getRendererForParticipant(String participantId) {
    if (participantId == _userId) {
      return _localRenderer;
    }

    // For demo, return null for remote participants since we don't have real remote streams
    // In a real implementation, you would map participant IDs to stream IDs
    return null;
  }

  // Speech recognition methods (not implemented, just for UI compatibility)
  @override
  Future<void> toggleSpeechRecognition() async {
    print('Speech recognition not implemented');
  }

  @override
  Future<void> startSpeechRecognition() async {
    print('Speech recognition not implemented');
  }

  @override
  Future<void> stopSpeechRecognition() async {
    print('Speech recognition not implemented');
  }

  @override
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      print('Sending message: $message');

      // Create and add message to local list
      final chatMessage = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _userId!,
        senderName: _displayName,
        text: message.trim(),
        timestamp: DateTime.now(),
        isMe: true,
      );

      _messages.add(chatMessage);
      notifyListeners();

      print('Message sent successfully');

    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    print('Disposing WebRTC Meeting Service...');
    _cleanup();
    super.dispose();
  }
}

// Model classes (same as before)
class ParticipantModel {
  final String id;
  final String name;
  final bool isSpeaking;
  final bool isMuted;
  final bool isHost;
  final bool isHandRaised;
  final bool isScreenSharing;
  final String? avatarUrl;

  ParticipantModel({
    required this.id,
    required this.name,
    this.isSpeaking = false,
    this.isMuted = false,
    this.isHost = false,
    this.isHandRaised = false,
    this.isScreenSharing = false,
    this.avatarUrl,
  });

  ParticipantModel copyWith({
    String? id,
    String? name,
    bool? isSpeaking,
    bool? isMuted,
    bool? isHost,
    bool? isHandRaised,
    bool? isScreenSharing,
    String? avatarUrl,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isMuted: isMuted ?? this.isMuted,
      isHost: isHost ?? this.isHost,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class SubtitleModel {
  final String id;
  final String speakerId;
  final String text;
  final String language;
  final DateTime timestamp;

  SubtitleModel({
    required this.id,
    required this.speakerId,
    required this.text,
    required this.language,
    required this.timestamp,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}