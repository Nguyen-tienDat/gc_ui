// lib/services/models.dart - Export models for use across the app

// Models from meeting_service.dart
class ParticipantModel {
  final String id;
  final String name;
  final bool isSpeaking;
  final bool isMuted;
  final bool isHost;
  final bool isHandRaised;
  final bool isScreenSharing;
  final String speakingLanguage;
  final String listeningLanguage;
  final bool isActive;
  final String? avatarUrl;  // ✅ ADDED MISSING PROPERTY

  ParticipantModel({
    required this.id,
    required this.name,
    this.isSpeaking = false,
    this.isMuted = true,
    this.isHost = false,
    this.isHandRaised = false,
    this.isScreenSharing = false,
    this.speakingLanguage = 'english',
    this.listeningLanguage = 'english',
    this.isActive = true,
    this.avatarUrl,  // ✅ ADDED TO CONSTRUCTOR
  });

  ParticipantModel copyWith({
    String? id,
    String? name,
    bool? isSpeaking,
    bool? isMuted,
    bool? isHost,
    bool? isHandRaised,
    bool? isScreenSharing,
    String? speakingLanguage,
    String? listeningLanguage,
    bool? isActive,
    String? avatarUrl,  // ✅ ADDED TO COPYWITH
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isMuted: isMuted ?? this.isMuted,
      isHost: isHost ?? this.isHost,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      speakingLanguage: speakingLanguage ?? this.speakingLanguage,
      listeningLanguage: listeningLanguage ?? this.listeningLanguage,
      isActive: isActive ?? this.isActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,  // ✅ ADDED TO COPYWITH
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.originalText = '',
    this.translatedText = '',
    this.sourceLanguage = 'en',
    this.targetLanguage = 'en',
  });
}

class SubtitleModel {
  final String id;
  final String speakerId;
  final String text;
  final String language;
  final DateTime timestamp;
  final String originalText;
  final String sourceLanguage;

  SubtitleModel({
    required this.id,
    required this.speakerId,
    required this.text,
    required this.language,
    required this.timestamp,
    this.originalText = '',
    this.sourceLanguage = '',
  });
}