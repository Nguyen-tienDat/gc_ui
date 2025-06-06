// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtitle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GcbSubtitleModel implements DiagnosticableTreeMixin {
  String get id;
  String get participantId;
  String get participantName;
  String get text;
  String get language;
  DateTime get timestamp;
  Duration get duration;

  /// Create a copy of GcbSubtitleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GcbSubtitleModelCopyWith<GcbSubtitleModel> get copyWith =>
      _$GcbSubtitleModelCopyWithImpl<GcbSubtitleModel>(
          this as GcbSubtitleModel, _$identity);

  /// Serializes this GcbSubtitleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbSubtitleModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('participantId', participantId))
      ..add(DiagnosticsProperty('participantName', participantName))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('duration', duration));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GcbSubtitleModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.participantName, participantName) ||
                other.participantName == participantName) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, participantId,
      participantName, text, language, timestamp, duration);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbSubtitleModel(id: $id, participantId: $participantId, participantName: $participantName, text: $text, language: $language, timestamp: $timestamp, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GcbSubtitleModelCopyWith<$Res> {
  factory $GcbSubtitleModelCopyWith(
          GcbSubtitleModel value, $Res Function(GcbSubtitleModel) _then) =
      _$GcbSubtitleModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String participantId,
      String participantName,
      String text,
      String language,
      DateTime timestamp,
      Duration duration});
}

/// @nodoc
class _$GcbSubtitleModelCopyWithImpl<$Res>
    implements $GcbSubtitleModelCopyWith<$Res> {
  _$GcbSubtitleModelCopyWithImpl(this._self, this._then);

  final GcbSubtitleModel _self;
  final $Res Function(GcbSubtitleModel) _then;

  /// Create a copy of GcbSubtitleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantId = null,
    Object? participantName = null,
    Object? text = null,
    Object? language = null,
    Object? timestamp = null,
    Object? duration = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      participantName: null == participantName
          ? _self.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GcbSubtitleModel
    with DiagnosticableTreeMixin
    implements GcbSubtitleModel {
  const _GcbSubtitleModel(
      {required this.id,
      required this.participantId,
      required this.participantName,
      required this.text,
      required this.language,
      required this.timestamp,
      required this.duration});
  factory _GcbSubtitleModel.fromJson(Map<String, dynamic> json) =>
      _$GcbSubtitleModelFromJson(json);

  @override
  final String id;
  @override
  final String participantId;
  @override
  final String participantName;
  @override
  final String text;
  @override
  final String language;
  @override
  final DateTime timestamp;
  @override
  final Duration duration;

  /// Create a copy of GcbSubtitleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GcbSubtitleModelCopyWith<_GcbSubtitleModel> get copyWith =>
      __$GcbSubtitleModelCopyWithImpl<_GcbSubtitleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GcbSubtitleModelToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbSubtitleModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('participantId', participantId))
      ..add(DiagnosticsProperty('participantName', participantName))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('duration', duration));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GcbSubtitleModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.participantName, participantName) ||
                other.participantName == participantName) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, participantId,
      participantName, text, language, timestamp, duration);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbSubtitleModel(id: $id, participantId: $participantId, participantName: $participantName, text: $text, language: $language, timestamp: $timestamp, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class _$GcbSubtitleModelCopyWith<$Res>
    implements $GcbSubtitleModelCopyWith<$Res> {
  factory _$GcbSubtitleModelCopyWith(
          _GcbSubtitleModel value, $Res Function(_GcbSubtitleModel) _then) =
      __$GcbSubtitleModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String participantId,
      String participantName,
      String text,
      String language,
      DateTime timestamp,
      Duration duration});
}

/// @nodoc
class __$GcbSubtitleModelCopyWithImpl<$Res>
    implements _$GcbSubtitleModelCopyWith<$Res> {
  __$GcbSubtitleModelCopyWithImpl(this._self, this._then);

  final _GcbSubtitleModel _self;
  final $Res Function(_GcbSubtitleModel) _then;

  /// Create a copy of GcbSubtitleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? participantId = null,
    Object? participantName = null,
    Object? text = null,
    Object? language = null,
    Object? timestamp = null,
    Object? duration = null,
  }) {
    return _then(_GcbSubtitleModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantId: null == participantId
          ? _self.participantId
          : participantId // ignore: cast_nullable_to_non_nullable
              as String,
      participantName: null == participantName
          ? _self.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

// dart format on
