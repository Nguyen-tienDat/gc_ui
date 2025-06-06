import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

@freezed
class GcbParticipantModel with _$GcbParticipantModel {
  const factory GcbParticipantModel({
    required String id,
    required String name,
    required bool isHost,
    required bool isModerator,
    required bool isMuted,
    required bool isVideoOn,
    required bool isScreenSharing,
    required bool isHandRaised,
    required bool isSpeaking,
    String? avatarUrl,
  }) = _GcbParticipantModel;

  factory GcbParticipantModel.fromJson(Map<String, dynamic> json) => 
    _$GcbParticipantModelFromJson(json);
}