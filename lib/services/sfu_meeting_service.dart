// lib/services/sfu_meeting_service.dart - CORRECT FILE NAME
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

// Export models for use in other files
export 'models.dart';

// ===== SFU MEETING SERVICE =====
class SfuMeetingService extends ChangeNotifier {
  // ===== METERED SFU CONFIG =====
  static const String SFU_APP_ID = '6839d2bdbf948087eec935dc';
  static const String SFU_SECRET = 'HB86MK9yUEN07hT/';
  static const String SFU_URL = 'https://global.sfu.metered.ca';
  static const String SFU_WS_URL = 'wss://global.sfu.metered.ca';

  // ===== CORE STATE =====
  String? _meetingId;
  String? _userId;
  String _displayName = '';
  bool _isHost = false;
  bool _isMeetingActive = false;
  String? _sfuRoomId;
  String? _accessToken;

  // ===== WEBRTC STATE =====
  MediaStream? _localStream;
  RTCVideoRenderer? _localRenderer;
  RTCPeerConnection? _publisherConnection;
  RTCPeerConnection? _subscriberConnection;

  // Remote streams from SFU
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, MediaStream> _remoteStreams = {};

  // ===== MEDIA CONTROLS =====
  bool _isMicrophoneEnabled = false;
  bool _isCameraEnabled = false;
  bool _isScreenSharing = false;
  bool _permissionsGranted = false;
  bool _mediaInitialized = false;

  // ===== SPEECH & TRANSLATION =====
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();
  bool _speechInitialized = false;
  bool _isListening = false;
  String _currentTranscription = '';
  String _sourceLanguage = 'en';
  String _targetLanguage = 'fr';

  // ===== DATA =====
  final List<ParticipantModel> _participants = [];
  final List<ChatMessage> _messages = [];
  final List<SubtitleModel> _subtitles = [];
  final List<StreamSubscription> _subscriptions = [];

  // ===== TIMING =====
  Duration _elapsedTime = const Duration();
  Timer? _meetingTimer;

  // ===== ICE SERVERS CONFIG =====
  final _iceServers = [
    {'urls': 'stun:stun.relay.metered.ca:80'},
    {
      'urls': 'turn:global.relay.metered.ca:80',
      'username': 'b573383c24e9d31f7db',
      'credential': 'tvAyXoixqazepn0',
    },
    {
      'urls': 'turn:global.relay.metered.ca:80?transport=tcp',
      'username': 'b573383c24e9d31f7db',
      'credential': 'tvAyXoixqazepn0',
    },
  ];

  // Language mapping
  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'vi': 'Vietnamese',
  };

  final Map<String, String> _speechLocaleMap = {
    'en': 'en-US',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'de': 'de-DE',
    'zh': 'zh-CN',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'vi': 'vi-VN',
  };

  // ===== GETTERS =====
  String? get meetingId => _meetingId;
  String? get userId => _userId;
  String get displayName => _displayName;
  bool get isHost => _isHost;
  bool get isMeetingActive => _isMeetingActive;
  bool get permissionsGranted => _permissionsGranted;
  bool get mediaInitialized => _mediaInitialized;
  bool get isMicrophoneEnabled => _isMicrophoneEnabled;
  bool get isCameraEnabled => _isCameraEnabled;
  bool get isScreenSharing => _isScreenSharing;
  bool get speechInitialized => _speechInitialized;
  bool get isListening => _isListening;
  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  String get speakingLanguage => _sourceLanguage;
  String get listeningLanguage => _targetLanguage;
  List<ParticipantModel> get participants => List.unmodifiable(_participants);
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<SubtitleModel> get subtitles => List.unmodifiable(_subtitles);
  RTCVideoRenderer? get localRenderer => _localRenderer;
  Map<String, String> get languages => _languages;
  Duration get elapsedTime => _elapsedTime;

  // ===== COMPUTED GETTERS =====
  int get participantCount => _participants.length;

  String get formattedElapsedTime {
    final hours = _elapsedTime.inHours;
    final minutes = _elapsedTime.inMinutes % 60;
    final seconds = _elapsedTime.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Get renderer for specific participant
  RTCVideoRenderer? getRendererForParticipant(String participantId) {
    if (participantId == _userId) {
      return _localRenderer;
    }
    return _remoteRenderers[participantId];
  }

  // ===== INITIALIZATION =====
  Future<void> initialize() async {
    try {
      print('🚀 Initializing SfuMeetingService...');
      _userId = const Uuid().v4();

      await _requestPermissions();
      await _initializeSpeechRecognition();
      await _initializeRenderers();

      print('✅ SfuMeetingService initialized successfully');
    } catch (e) {
      print('❌ Error initializing service: $e');
      rethrow;
    }
  }

  Future<void> _requestPermissions() async {
    try {
      await Permission.microphone.request();
      await Permission.camera.request();

      final micStatus = await Permission.microphone.isGranted;
      final camStatus = await Permission.camera.isGranted;

      _permissionsGranted = micStatus && camStatus;
      print('📋 Permissions granted: $_permissionsGranted');
    } catch (e) {
      print('❌ Error requesting permissions: $e');
      _permissionsGranted = false;
    }
  }

  Future<void> _initializeSpeechRecognition() async {
    try {
      _speechInitialized = await _speechToText.initialize(
        onStatus: (status) {
          print('🎤 Speech status: $status');
          if (status == 'done') {
            _isListening = false;
            notifyListeners();
          }
        },
        onError: (error) {
          print('❌ Speech error: $error');
          _isListening = false;
          notifyListeners();
        },
      );
      print('🎤 Speech recognition initialized: $_speechInitialized');
    } catch (e) {
      print('❌ Error initializing speech recognition: $e');
      _speechInitialized = false;
    }
  }

  Future<void> _initializeRenderers() async {
    try {
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();
      print('📹 Local video renderer initialized');
    } catch (e) {
      print('❌ Error initializing renderers: $e');
    }
  }

  // ===== USER & LANGUAGE SETTINGS =====
  void setUserDetails({required String displayName, String? userId}) {
    _displayName = displayName;
    if (userId != null) _userId = userId;
    print('👤 User details set: $_displayName ($_userId)');
    notifyListeners();
  }

  void setLanguagePreferences({required String speaking, required String listening}) {
    _sourceLanguage = speaking.toLowerCase();
    _targetLanguage = listening.toLowerCase();
    print('🌐 Language preferences set: speaking=$speaking, listening=$listening');
    notifyListeners();
  }

  // ===== SFU API METHODS (Simplified for now) =====
  String _generateAccessToken() {
    // Simple token generation - in production use proper JWT
    final payload = {
      'appId': SFU_APP_ID,
      'userId': _userId,
      'exp': (DateTime.now().millisecondsSinceEpoch / 1000).round() + 3600,
    };
    return base64Encode(utf8.encode(jsonEncode(payload)));
  }

  // ===== MEETING MANAGEMENT =====
  Future<String> createMeeting({
    required String topic,
    String? password,
    required String hostLanguage,
    required List<String> translationLanguages,
  }) async {
    try {
      print('🏗️ Creating SFU meeting: $topic');

      _isHost = true;
      _sourceLanguage = hostLanguage.toLowerCase();
      if (translationLanguages.isNotEmpty) {
        _targetLanguage = translationLanguages.first.toLowerCase();
      }

      // For now, simulate SFU room creation
      _sfuRoomId = 'sfu-room-${const Uuid().v4().substring(0, 8)}';
      _accessToken = _generateAccessToken();
      _meetingId = 'SFU-${const Uuid().v4().substring(0, 8)}';

      // Create meeting document
      await FirebaseFirestore.instance.collection('meetings').doc(_meetingId).set({
        'meetingId': _meetingId,
        'sfuRoomId': _sfuRoomId,
        'topic': topic,
        'createdBy': _userId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'hostName': _displayName,
        'hostId': _userId,
        'hostLanguage': hostLanguage,
        'translationLanguages': translationLanguages,
        'password': password?.trim() ?? '',
        'connectionType': 'sfu',
      });

      // Setup media and connections
      await _setupLocalMedia();

      // TODO: Setup SFU connections here
      // await _setupSfuPublisher();
      // await _setupSfuSubscriber();

      // Add self as participant
      await _addSelfAsParticipant();

      // Start listeners
      _listenForParticipants();
      _startListeningForMessages();
      _listenForSubtitles();
      _startMeetingTimer();

      _isMeetingActive = true;
      notifyListeners();

      print('✅ SFU Meeting created: $_meetingId (Room: $_sfuRoomId)');
      return _meetingId!;

    } catch (e) {
      print('❌ Error creating SFU meeting: $e');
      rethrow;
    }
  }

  Future<void> joinMeeting({
    required String meetingId,
    String? password,
  }) async {
    try {
      print('🚪 Joining SFU meeting: $meetingId');

      // Check if meeting exists
      final meetingDoc = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(meetingId)
          .get();

      if (!meetingDoc.exists) {
        throw Exception('Meeting not found');
      }

      final meetingData = meetingDoc.data()!;

      // Check password if required
      if (meetingData['password'] != null && meetingData['password'].isNotEmpty) {
        if (meetingData['password'] != (password?.trim() ?? '')) {
          throw Exception('Incorrect password');
        }
      }

      _meetingId = meetingId;
      _sfuRoomId = meetingData['sfuRoomId'];
      _isHost = false;

      // Get language settings
      _sourceLanguage = (meetingData['hostLanguage'] ?? 'english').toLowerCase();
      final translationLangs = List<String>.from(meetingData['translationLanguages'] ?? ['english']);
      if (translationLangs.isNotEmpty) {
        _targetLanguage = translationLangs.first.toLowerCase();
      }

      // Setup media and connections
      await _setupLocalMedia();

      // TODO: Setup SFU connections here
      // await _setupSfuPublisher();
      // await _setupSfuSubscriber();

      // Add self as participant
      await _addSelfAsParticipant();

      // Start listeners
      _listenForParticipants();
      _startListeningForMessages();
      _listenForSubtitles();
      _startMeetingTimer();

      _isMeetingActive = true;
      notifyListeners();

      print('✅ Joined SFU meeting successfully');

    } catch (e) {
      print('❌ Error joining SFU meeting: $e');
      rethrow;
    }
  }

  // ===== MEDIA SETUP =====
  Future<void> _setupLocalMedia() async {
    try {
      print('📹 Setting up local media...');

      if (!_permissionsGranted) {
        throw Exception('Permissions not granted');
      }

      final constraints = {
        'audio': {
          'echoCancellation': true,
          'autoGainControl': true,
          'noiseSuppression': true,
        },
        'video': {
          'width': {'ideal': 640},
          'height': {'ideal': 480},
          'frameRate': {'ideal': 15},
          'facingMode': 'user',
        },
      };

      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _localRenderer!.srcObject = _localStream;

      // Start with media disabled
      final audioTracks = _localStream!.getAudioTracks();
      final videoTracks = _localStream!.getVideoTracks();

      if (audioTracks.isNotEmpty) {
        audioTracks.first.enabled = false;
        _isMicrophoneEnabled = false;
      }

      if (videoTracks.isNotEmpty) {
        videoTracks.first.enabled = false;
        _isCameraEnabled = false;
      }

      _mediaInitialized = true;
      print('✅ Local media setup completed');
      notifyListeners();

    } catch (e) {
      print('❌ Error setting up media: $e');
      rethrow;
    }
  }

  // ===== MEDIA CONTROLS =====
  Future<void> toggleMicrophone() async {
    if (_localStream == null) return;

    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      final newState = !audioTracks.first.enabled;
      audioTracks.first.enabled = newState;
      _isMicrophoneEnabled = newState;

      await _updateSelfParticipantState();
      notifyListeners();

      print('🎤 Microphone ${newState ? 'enabled' : 'disabled'}');
    }
  }

  Future<void> toggleCamera() async {
    if (_localStream == null) return;

    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      final newState = !videoTracks.first.enabled;
      videoTracks.first.enabled = newState;
      _isCameraEnabled = newState;

      await _updateSelfParticipantState();
      notifyListeners();

      print('📹 Camera ${newState ? 'enabled' : 'disabled'}');
    }
  }

  Future<void> toggleHandRaised() async {
    try {
      if (_meetingId == null || _userId == null) return;

      bool currentHandRaised = false;
      try {
        final participant = _participants.firstWhere((p) => p.id == _userId);
        currentHandRaised = participant.isHandRaised;
      } catch (e) {
        currentHandRaised = false;
      }

      final newHandRaised = !currentHandRaised;

      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('participants')
          .doc(_userId)
          .update({
        'isHandRaised': newHandRaised,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('✋ Hand raised toggled to: $newHandRaised');
    } catch (e) {
      print('❌ Error toggling hand raised: $e');
      rethrow;
    }
  }

  Future<void> toggleScreenSharing() async {
    try {
      _isScreenSharing = !_isScreenSharing;
      await _updateSelfParticipantState();
      notifyListeners();
      print('🖥️ Screen sharing toggled to: $_isScreenSharing');
    } catch (e) {
      print('❌ Error toggling screen sharing: $e');
      rethrow;
    }
  }

  Future<void> toggleSpeechRecognition() async {
    if (!_isMeetingActive || _meetingId == null) return;

    if (!_isListening) {
      await _startListening();
    } else {
      await _stopListening();
    }
  }

  // ===== PARTICIPANT MANAGEMENT =====
  Future<void> _addSelfAsParticipant() async {
    try {
      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('participants')
          .doc(_userId)
          .set({
        'displayName': _displayName,
        'isHost': _isHost,
        'joinedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'isMuted': true,
        'isCameraOff': true,
        'isHandRaised': false,
        'isScreenSharing': false,
        'isSpeaking': false,
        'speakingLanguage': _sourceLanguage,
        'listeningLanguage': _targetLanguage,
        'avatarUrl': null,
        'connectionType': 'sfu',
        'sfuStreamId': _localStream?.id,
      });

      print('👤 Added self as SFU participant');
    } catch (e) {
      print('❌ Error adding SFU participant: $e');
    }
  }

  void _listenForParticipants() {
    if (_meetingId == null) return;

    final subscription = FirebaseFirestore.instance
        .collection('meetings')
        .doc(_meetingId)
        .collection('participants')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {

      print('👥 SFU Participants update: ${snapshot.docs.length} total');

      final List<ParticipantModel> newParticipants = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final participantId = doc.id;

        final participant = ParticipantModel(
          id: participantId,
          name: participantId == _userId
              ? '${data['displayName'] ?? 'Unknown'} (You)'
              : data['displayName'] ?? 'Unknown',
          isSpeaking: data['isSpeaking'] ?? false,
          isMuted: data['isMuted'] ?? true,
          isHost: data['isHost'] ?? false,
          isHandRaised: data['isHandRaised'] ?? false,
          isScreenSharing: data['isScreenSharing'] ?? false,
          speakingLanguage: data['speakingLanguage'] ?? 'en',
          listeningLanguage: data['listeningLanguage'] ?? 'en',
          avatarUrl: data['avatarUrl'],
        );

        newParticipants.add(participant);
      }

      _participants.clear();
      _participants.addAll(newParticipants);

      print('👥 SFU Participants updated: ${_participants.length} total');
      notifyListeners();
    });

    _subscriptions.add(subscription);
  }

  Future<void> _updateSelfParticipantState() async {
    if (_meetingId == null || _userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('participants')
          .doc(_userId)
          .update({
        'isMuted': !_isMicrophoneEnabled,
        'isCameraOff': !_isCameraEnabled,
        'isScreenSharing': _isScreenSharing,
        'isSpeaking': _isListening,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ Error updating SFU participant state: $e');
    }
  }

  // ===== SPEECH RECOGNITION & TRANSLATION =====
  Future<void> _startListening() async {
    if (!_speechInitialized) return;

    try {
      final localeId = _speechLocaleMap[_sourceLanguage] ?? 'en-US';
      _isListening = true;

      await _speechToText.listen(
        localeId: localeId,
        onResult: (result) async {
          if (result.finalResult) {
            final recognizedText = result.recognizedWords;
            _currentTranscription = recognizedText;

            if (recognizedText.isNotEmpty) {
              await _translateAndStoreText(recognizedText);
            }

            _isListening = false;
            notifyListeners();
          } else {
            _currentTranscription = result.recognizedWords;
            notifyListeners();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        cancelOnError: false,
      );

      await _updateSelfParticipantState();
      notifyListeners();

    } catch (e) {
      _isListening = false;
      notifyListeners();
      print('❌ Error starting speech recognition: $e');
    }
  }

  Future<void> _stopListening() async {
    _isListening = false;
    await _speechToText.stop();
    await _updateSelfParticipantState();
    notifyListeners();
  }

  Future<void> _translateAndStoreText(String text) async {
    if (text.isEmpty || _meetingId == null) return;

    try {
      final translation = await _translator.translate(
        text,
        from: _sourceLanguage,
        to: _targetLanguage,
      );

      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('messages')
          .add({
        'originalText': text,
        'translatedText': translation.text,
        'timestamp': FieldValue.serverTimestamp(),
        'sourceLanguage': _sourceLanguage,
        'targetLanguage': _targetLanguage,
        'senderId': _userId,
        'senderName': _displayName,
        'isHost': _isHost,
        'messageType': 'speech',
      });

      print('💬 SFU Speech message stored: "$text" -> "${translation.text}"');
    } catch (e) {
      print('❌ SFU Translation error: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    try {
      if (_meetingId == null || _userId == null || text.trim().isEmpty) return;

      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('messages')
          .add({
        'senderId': _userId,
        'senderName': _displayName,
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'originalText': text.trim(),
        'translatedText': text.trim(),
        'sourceLanguage': _sourceLanguage,
        'targetLanguage': _targetLanguage,
        'messageType': 'chat',
      });

      print('💬 SFU Chat message sent successfully');
    } catch (e) {
      print('❌ Error sending SFU message: $e');
      rethrow;
    }
  }

  void _startListeningForMessages() {
    if (_meetingId == null) return;

    final subscription = FirebaseFirestore.instance
        .collection('meetings')
        .doc(_meetingId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final message = ChatMessage(
          id: doc.id,
          senderId: data['senderId'] ?? '',
          senderName: data['senderName'] ?? 'Unknown',
          text: data['translatedText'] ?? data['originalText'] ?? '',
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          isMe: data['senderId'] == _userId,
          originalText: data['originalText'] ?? '',
          translatedText: data['translatedText'] ?? '',
          sourceLanguage: data['sourceLanguage'] ?? 'en',
          targetLanguage: data['targetLanguage'] ?? 'en',
        );
        _messages.add(message);
      }

      notifyListeners();
    });

    _subscriptions.add(subscription);
  }

  void _listenForSubtitles() {
    if (_meetingId == null) return;

    final subscription = FirebaseFirestore.instance
        .collection('meetings')
        .doc(_meetingId)
        .collection('subtitles')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .listen((snapshot) {
      _subtitles.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final subtitle = SubtitleModel(
          id: doc.id,
          speakerId: data['speakerId'] ?? '',
          text: data['text'] ?? '',
          language: data['language'] ?? 'english',
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          originalText: data['originalText'] ?? '',
          sourceLanguage: data['sourceLanguage'] ?? '',
        );
        _subtitles.add(subtitle);
      }

      notifyListeners();
    });

    _subscriptions.add(subscription);
  }

  // ===== LANGUAGE CONTROLS =====
  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    notifyListeners();
  }

  void setTargetLanguage(String language) {
    _targetLanguage = language;
    notifyListeners();
  }

  // ===== MEETING TIMER =====
  void _startMeetingTimer() {
    _meetingTimer?.cancel();
    _elapsedTime = const Duration();
    _meetingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime = Duration(seconds: _elapsedTime.inSeconds + 1);
      notifyListeners();
    });
    print('⏰ SFU Meeting timer started');
  }

  // ===== MEETING CONTROL =====
  Future<void> endMeetingForAll() async {
    try {
      if (_meetingId == null || !_isHost) {
        throw Exception('Only host can end meeting for all');
      }

      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .update({
        'status': 'ended',
        'endedAt': FieldValue.serverTimestamp(),
        'endedBy': _userId,
      });

      await _cleanup();
      print('✅ SFU Meeting ended for all participants');
    } catch (e) {
      print('❌ Error ending SFU meeting: $e');
      rethrow;
    }
  }

  Future<void> leaveMeetingAsParticipant() async {
    try {
      if (_meetingId == null || _userId == null) return;

      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_meetingId)
          .collection('participants')
          .doc(_userId)
          .update({
        'isActive': false,
        'leftAt': FieldValue.serverTimestamp(),
      });

      await _cleanup();
      print('✅ Left SFU meeting successfully');
    } catch (e) {
      print('❌ Error leaving SFU meeting: $e');
      rethrow;
    }
  }

  // ===== BACKWARD COMPATIBILITY ALIASES =====
  Future<void> endCall() async => await endMeetingForAll();
  Future<void> leaveCall() async => await leaveMeetingAsParticipant();

  Future<void> endOrLeaveCall() async {
    if (_isHost) {
      await endMeetingForAll();
    } else {
      await leaveMeetingAsParticipant();
    }
  }

  // ===== DEBUG =====
  void debugStates() {
    print('=== SFU MEETING SERVICE DEBUG ===');
    print('Meeting ID: $_meetingId');
    print('SFU Room ID: $_sfuRoomId');
    print('User ID: $_userId');
    print('Display Name: $_displayName');
    print('Is Host: $_isHost');
    print('Meeting Active: $_isMeetingActive');
    print('Access Token: ${_accessToken?.substring(0, 20)}...');
    print('Media Initialized: $_mediaInitialized');
    print('Permissions Granted: $_permissionsGranted');
    print('--- Media States ---');
    print('Microphone: $_isMicrophoneEnabled');
    print('Camera: $_isCameraEnabled');
    print('Screen Sharing: $_isScreenSharing');
    print('Speech Recognition: $_isListening');
    print('--- Languages ---');
    print('Source: $_sourceLanguage');
    print('Target: $_targetLanguage');
    print('--- Data ---');
    print('Participants: ${_participants.length}');
    print('Messages: ${_messages.length}');
    print('Subtitles: ${_subtitles.length}');
    print('Remote Renderers: ${_remoteRenderers.length}');
    print('Remote Streams: ${_remoteStreams.length}');
    print('--- WebRTC Connections ---');
    print('Publisher Connection: ${_publisherConnection?.connectionState}');
    print('Subscriber Connection: ${_subscriberConnection?.connectionState}');
    print('Local Stream: ${_localStream?.id}');
    print('===========================');
  }

  // ===== CLEANUP =====
  Future<void> _cleanup() async {
    try {
      _meetingTimer?.cancel();
      _meetingTimer = null;

      for (var subscription in _subscriptions) {
        await subscription.cancel();
      }
      _subscriptions.clear();

      // Close WebRTC connections
      await _publisherConnection?.close();
      await _subscriberConnection?.close();
      _publisherConnection = null;
      _subscriberConnection = null;

      // Dispose renderers
      for (var renderer in _remoteRenderers.values) {
        await renderer.dispose();
      }
      _remoteRenderers.clear();

      // Stop local stream
      _localStream?.getTracks().forEach((track) => track.stop());
      _localStream = null;

      await _localRenderer?.dispose();
      _localRenderer = null;

      await _speechToText.cancel();

      // Clear state
      _meetingId = null;
      _sfuRoomId = null;
      _accessToken = null;
      _isMeetingActive = false;
      _participants.clear();
      _messages.clear();
      _subtitles.clear();
      _remoteStreams.clear();
      _elapsedTime = const Duration();

      print('🧹 SFU Cleanup completed');
      notifyListeners();

    } catch (e) {
      print('❌ Error during SFU cleanup: $e');
    }
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}