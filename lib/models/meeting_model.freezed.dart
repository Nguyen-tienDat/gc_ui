// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GcbMeetingModel implements DiagnosticableTreeMixin {
  String get id;
  String get code;
  String get topic;
  DateTime get startTime;
  int get durationMinutes;
  String get hostId;
  String get hostName;
  List<String> get participantIds;
  bool get isRecording;
  String get primaryLanguage;
  List<String> get translationLanguages;
  String? get description;
  String? get password;

  /// Create a copy of GcbMeetingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GcbMeetingModelCopyWith<GcbMeetingModel> get copyWith =>
      _$GcbMeetingModelCopyWithImpl<GcbMeetingModel>(
          this as GcbMeetingModel, _$identity);

  /// Serializes this GcbMeetingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbMeetingModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('topic', topic))
      ..add(DiagnosticsProperty('startTime', startTime))
      ..add(DiagnosticsProperty('durationMinutes', durationMinutes))
      ..add(DiagnosticsProperty('hostId', hostId))
      ..add(DiagnosticsProperty('hostName', hostName))
      ..add(DiagnosticsProperty('participantIds', participantIds))
      ..add(DiagnosticsProperty('isRecording', isRecording))
      ..add(DiagnosticsProperty('primaryLanguage', primaryLanguage))
      ..add(DiagnosticsProperty('translationLanguages', translationLanguages))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GcbMeetingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            const DeepCollectionEquality()
                .equals(other.participantIds, participantIds) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.primaryLanguage, primaryLanguage) ||
                other.primaryLanguage == primaryLanguage) &&
            const DeepCollectionEquality()
                .equals(other.translationLanguages, translationLanguages) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      topic,
      startTime,
      durationMinutes,
      hostId,
      hostName,
      const DeepCollectionEquality().hash(participantIds),
      isRecording,
      primaryLanguage,
      const DeepCollectionEquality().hash(translationLanguages),
      description,
      password);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbMeetingModel(id: $id, code: $code, topic: $topic, startTime: $startTime, durationMinutes: $durationMinutes, hostId: $hostId, hostName: $hostName, participantIds: $participantIds, isRecording: $isRecording, primaryLanguage: $primaryLanguage, translationLanguages: $translationLanguages, description: $description, password: $password)';
  }
}

/// @nodoc
abstract mixin class $GcbMeetingModelCopyWith<$Res> {
  factory $GcbMeetingModelCopyWith(
          GcbMeetingModel value, $Res Function(GcbMeetingModel) _then) =
      _$GcbMeetingModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String code,
      String topic,
      DateTime startTime,
      int durationMinutes,
      String hostId,
      String hostName,
      List<String> participantIds,
      bool isRecording,
      String primaryLanguage,
      List<String> translationLanguages,
      String? description,
      String? password});
}

/// @nodoc
class _$GcbMeetingModelCopyWithImpl<$Res>
    implements $GcbMeetingModelCopyWith<$Res> {
  _$GcbMeetingModelCopyWithImpl(this._self, this._then);

  final GcbMeetingModel _self;
  final $Res Function(GcbMeetingModel) _then;

  /// Create a copy of GcbMeetingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? topic = null,
    Object? startTime = null,
    Object? durationMinutes = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? participantIds = null,
    Object? isRecording = null,
    Object? primaryLanguage = null,
    Object? translationLanguages = null,
    Object? description = freezed,
    Object? password = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _self.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _self.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      hostName: null == hostName
          ? _self.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _self.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRecording: null == isRecording
          ? _self.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryLanguage: null == primaryLanguage
          ? _self.primaryLanguage
          : primaryLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      translationLanguages: null == translationLanguages
          ? _self.translationLanguages
          : translationLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GcbMeetingModel with DiagnosticableTreeMixin implements GcbMeetingModel {
  const _GcbMeetingModel(
      {required this.id,
      required this.code,
      required this.topic,
      required this.startTime,
      required this.durationMinutes,
      required this.hostId,
      required this.hostName,
      required final List<String> participantIds,
      required this.isRecording,
      required this.primaryLanguage,
      required final List<String> translationLanguages,
      this.description,
      this.password})
      : _participantIds = participantIds,
        _translationLanguages = translationLanguages;
  factory _GcbMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$GcbMeetingModelFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String topic;
  @override
  final DateTime startTime;
  @override
  final int durationMinutes;
  @override
  final String hostId;
  @override
  final String hostName;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  final bool isRecording;
  @override
  final String primaryLanguage;
  final List<String> _translationLanguages;
  @override
  List<String> get translationLanguages {
    if (_translationLanguages is EqualUnmodifiableListView)
      return _translationLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translationLanguages);
  }

  @override
  final String? description;
  @override
  final String? password;

  /// Create a copy of GcbMeetingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GcbMeetingModelCopyWith<_GcbMeetingModel> get copyWith =>
      __$GcbMeetingModelCopyWithImpl<_GcbMeetingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GcbMeetingModelToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbMeetingModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('topic', topic))
      ..add(DiagnosticsProperty('startTime', startTime))
      ..add(DiagnosticsProperty('durationMinutes', durationMinutes))
      ..add(DiagnosticsProperty('hostId', hostId))
      ..add(DiagnosticsProperty('hostName', hostName))
      ..add(DiagnosticsProperty('participantIds', participantIds))
      ..add(DiagnosticsProperty('isRecording', isRecording))
      ..add(DiagnosticsProperty('primaryLanguage', primaryLanguage))
      ..add(DiagnosticsProperty('translationLanguages', translationLanguages))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GcbMeetingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.primaryLanguage, primaryLanguage) ||
                other.primaryLanguage == primaryLanguage) &&
            const DeepCollectionEquality()
                .equals(other._translationLanguages, _translationLanguages) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      topic,
      startTime,
      durationMinutes,
      hostId,
      hostName,
      const DeepCollectionEquality().hash(_participantIds),
      isRecording,
      primaryLanguage,
      const DeepCollectionEquality().hash(_translationLanguages),
      description,
      password);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbMeetingModel(id: $id, code: $code, topic: $topic, startTime: $startTime, durationMinutes: $durationMinutes, hostId: $hostId, hostName: $hostName, participantIds: $participantIds, isRecording: $isRecording, primaryLanguage: $primaryLanguage, translationLanguages: $translationLanguages, description: $description, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$GcbMeetingModelCopyWith<$Res>
    implements $GcbMeetingModelCopyWith<$Res> {
  factory _$GcbMeetingModelCopyWith(
          _GcbMeetingModel value, $Res Function(_GcbMeetingModel) _then) =
      __$GcbMeetingModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String topic,
      DateTime startTime,
      int durationMinutes,
      String hostId,
      String hostName,
      List<String> participantIds,
      bool isRecording,
      String primaryLanguage,
      List<String> translationLanguages,
      String? description,
      String? password});
}

/// @nodoc
class __$GcbMeetingModelCopyWithImpl<$Res>
    implements _$GcbMeetingModelCopyWith<$Res> {
  __$GcbMeetingModelCopyWithImpl(this._self, this._then);

  final _GcbMeetingModel _self;
  final $Res Function(_GcbMeetingModel) _then;

  /// Create a copy of GcbMeetingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? topic = null,
    Object? startTime = null,
    Object? durationMinutes = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? participantIds = null,
    Object? isRecording = null,
    Object? primaryLanguage = null,
    Object? translationLanguages = null,
    Object? description = freezed,
    Object? password = freezed,
  }) {
    return _then(_GcbMeetingModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _self.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _self.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      hostName: null == hostName
          ? _self.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _self._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRecording: null == isRecording
          ? _self.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryLanguage: null == primaryLanguage
          ? _self.primaryLanguage
          : primaryLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      translationLanguages: null == translationLanguages
          ? _self._translationLanguages
          : translationLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
