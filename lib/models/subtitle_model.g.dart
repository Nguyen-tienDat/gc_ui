// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GcbSubtitleModel _$GcbSubtitleModelFromJson(Map<String, dynamic> json) =>
    _GcbSubtitleModel(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      text: json['text'] as String,
      language: json['language'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
    );

Map<String, dynamic> _$GcbSubtitleModelToJson(_GcbSubtitleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantId': instance.participantId,
      'participantName': instance.participantName,
      'text': instance.text,
      'language': instance.language,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
    };
