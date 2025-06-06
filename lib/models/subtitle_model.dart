import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtitle_model.freezed.dart';
part 'subtitle_model.g.dart';

@freezed
class GcbSubtitleModel with _$GcbSubtitleModel {
  const factory GcbSubtitleModel({
    required String id,
    required String participantId,
    required String participantName,
    required String text,
    required String language,
    required DateTime timestamp,
    required Duration duration,
  }) = _GcbSubtitleModel;

  factory GcbSubtitleModel.fromJson(Map<String, dynamic> json) => 
    _$GcbSubtitleModelFromJson(json);
}