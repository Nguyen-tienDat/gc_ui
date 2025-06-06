// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GcbParticipantModel implements DiagnosticableTreeMixin {
  String get id;
  String get name;
  bool get isHost;
  bool get isModerator;
  bool get isMuted;
  bool get isVideoOn;
  bool get isScreenSharing;
  bool get isHandRaised;
  bool get isSpeaking;
  String? get avatarUrl;

  /// Create a copy of GcbParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GcbParticipantModelCopyWith<GcbParticipantModel> get copyWith =>
      _$GcbParticipantModelCopyWithImpl<GcbParticipantModel>(
          this as GcbParticipantModel, _$identity);

  /// Serializes this GcbParticipantModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbParticipantModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('isHost', isHost))
      ..add(DiagnosticsProperty('isModerator', isModerator))
      ..add(DiagnosticsProperty('isMuted', isMuted))
      ..add(DiagnosticsProperty('isVideoOn', isVideoOn))
      ..add(DiagnosticsProperty('isScreenSharing', isScreenSharing))
      ..add(DiagnosticsProperty('isHandRaised', isHandRaised))
      ..add(DiagnosticsProperty('isSpeaking', isSpeaking))
      ..add(DiagnosticsProperty('avatarUrl', avatarUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GcbParticipantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isHost, isHost) || other.isHost == isHost) &&
            (identical(other.isModerator, isModerator) ||
                other.isModerator == isModerator) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.isVideoOn, isVideoOn) ||
                other.isVideoOn == isVideoOn) &&
            (identical(other.isScreenSharing, isScreenSharing) ||
                other.isScreenSharing == isScreenSharing) &&
            (identical(other.isHandRaised, isHandRaised) ||
                other.isHandRaised == isHandRaised) &&
            (identical(other.isSpeaking, isSpeaking) ||
                other.isSpeaking == isSpeaking) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isHost, isModerator,
      isMuted, isVideoOn, isScreenSharing, isHandRaised, isSpeaking, avatarUrl);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbParticipantModel(id: $id, name: $name, isHost: $isHost, isModerator: $isModerator, isMuted: $isMuted, isVideoOn: $isVideoOn, isScreenSharing: $isScreenSharing, isHandRaised: $isHandRaised, isSpeaking: $isSpeaking, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class $GcbParticipantModelCopyWith<$Res> {
  factory $GcbParticipantModelCopyWith(
          GcbParticipantModel value, $Res Function(GcbParticipantModel) _then) =
      _$GcbParticipantModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isHost,
      bool isModerator,
      bool isMuted,
      bool isVideoOn,
      bool isScreenSharing,
      bool isHandRaised,
      bool isSpeaking,
      String? avatarUrl});
}

/// @nodoc
class _$GcbParticipantModelCopyWithImpl<$Res>
    implements $GcbParticipantModelCopyWith<$Res> {
  _$GcbParticipantModelCopyWithImpl(this._self, this._then);

  final GcbParticipantModel _self;
  final $Res Function(GcbParticipantModel) _then;

  /// Create a copy of GcbParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isHost = null,
    Object? isModerator = null,
    Object? isMuted = null,
    Object? isVideoOn = null,
    Object? isScreenSharing = null,
    Object? isHandRaised = null,
    Object? isSpeaking = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isHost: null == isHost
          ? _self.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
      isModerator: null == isModerator
          ? _self.isModerator
          : isModerator // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _self.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoOn: null == isVideoOn
          ? _self.isVideoOn
          : isVideoOn // ignore: cast_nullable_to_non_nullable
              as bool,
      isScreenSharing: null == isScreenSharing
          ? _self.isScreenSharing
          : isScreenSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      isHandRaised: null == isHandRaised
          ? _self.isHandRaised
          : isHandRaised // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpeaking: null == isSpeaking
          ? _self.isSpeaking
          : isSpeaking // ignore: cast_nullable_to_non_nullable
              as bool,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GcbParticipantModel
    with DiagnosticableTreeMixin
    implements GcbParticipantModel {
  const _GcbParticipantModel(
      {required this.id,
      required this.name,
      required this.isHost,
      required this.isModerator,
      required this.isMuted,
      required this.isVideoOn,
      required this.isScreenSharing,
      required this.isHandRaised,
      required this.isSpeaking,
      this.avatarUrl});
  factory _GcbParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$GcbParticipantModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isHost;
  @override
  final bool isModerator;
  @override
  final bool isMuted;
  @override
  final bool isVideoOn;
  @override
  final bool isScreenSharing;
  @override
  final bool isHandRaised;
  @override
  final bool isSpeaking;
  @override
  final String? avatarUrl;

  /// Create a copy of GcbParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GcbParticipantModelCopyWith<_GcbParticipantModel> get copyWith =>
      __$GcbParticipantModelCopyWithImpl<_GcbParticipantModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GcbParticipantModelToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'GcbParticipantModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('isHost', isHost))
      ..add(DiagnosticsProperty('isModerator', isModerator))
      ..add(DiagnosticsProperty('isMuted', isMuted))
      ..add(DiagnosticsProperty('isVideoOn', isVideoOn))
      ..add(DiagnosticsProperty('isScreenSharing', isScreenSharing))
      ..add(DiagnosticsProperty('isHandRaised', isHandRaised))
      ..add(DiagnosticsProperty('isSpeaking', isSpeaking))
      ..add(DiagnosticsProperty('avatarUrl', avatarUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GcbParticipantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isHost, isHost) || other.isHost == isHost) &&
            (identical(other.isModerator, isModerator) ||
                other.isModerator == isModerator) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.isVideoOn, isVideoOn) ||
                other.isVideoOn == isVideoOn) &&
            (identical(other.isScreenSharing, isScreenSharing) ||
                other.isScreenSharing == isScreenSharing) &&
            (identical(other.isHandRaised, isHandRaised) ||
                other.isHandRaised == isHandRaised) &&
            (identical(other.isSpeaking, isSpeaking) ||
                other.isSpeaking == isSpeaking) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isHost, isModerator,
      isMuted, isVideoOn, isScreenSharing, isHandRaised, isSpeaking, avatarUrl);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GcbParticipantModel(id: $id, name: $name, isHost: $isHost, isModerator: $isModerator, isMuted: $isMuted, isVideoOn: $isVideoOn, isScreenSharing: $isScreenSharing, isHandRaised: $isHandRaised, isSpeaking: $isSpeaking, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class _$GcbParticipantModelCopyWith<$Res>
    implements $GcbParticipantModelCopyWith<$Res> {
  factory _$GcbParticipantModelCopyWith(_GcbParticipantModel value,
          $Res Function(_GcbParticipantModel) _then) =
      __$GcbParticipantModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isHost,
      bool isModerator,
      bool isMuted,
      bool isVideoOn,
      bool isScreenSharing,
      bool isHandRaised,
      bool isSpeaking,
      String? avatarUrl});
}

/// @nodoc
class __$GcbParticipantModelCopyWithImpl<$Res>
    implements _$GcbParticipantModelCopyWith<$Res> {
  __$GcbParticipantModelCopyWithImpl(this._self, this._then);

  final _GcbParticipantModel _self;
  final $Res Function(_GcbParticipantModel) _then;

  /// Create a copy of GcbParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isHost = null,
    Object? isModerator = null,
    Object? isMuted = null,
    Object? isVideoOn = null,
    Object? isScreenSharing = null,
    Object? isHandRaised = null,
    Object? isSpeaking = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_GcbParticipantModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isHost: null == isHost
          ? _self.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
      isModerator: null == isModerator
          ? _self.isModerator
          : isModerator // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _self.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      isVideoOn: null == isVideoOn
          ? _self.isVideoOn
          : isVideoOn // ignore: cast_nullable_to_non_nullable
              as bool,
      isScreenSharing: null == isScreenSharing
          ? _self.isScreenSharing
          : isScreenSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      isHandRaised: null == isHandRaised
          ? _self.isHandRaised
          : isHandRaised // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpeaking: null == isSpeaking
          ? _self.isSpeaking
          : isSpeaking // ignore: cast_nullable_to_non_nullable
              as bool,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
