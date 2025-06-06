import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_model.freezed.dart';
part 'meeting_model.g.dart';

@freezed
class GcbMeetingModel with _$GcbMeetingModel {
  const factory GcbMeetingModel({
    required String id,
    required String code,
    required String topic,
    required DateTime startTime,
    required int durationMinutes,
    required String hostId,
    required String hostName,
    required List<String> participantIds,
    required bool isRecording,
    required String primaryLanguage,
    required List<String> translationLanguages,
    String? description,
    String? password,
  }) = _GcbMeetingModel;

  factory GcbMeetingModel.fromJson(Map<String, dynamic> json) => 
    _$GcbMeetingModelFromJson(json);
}