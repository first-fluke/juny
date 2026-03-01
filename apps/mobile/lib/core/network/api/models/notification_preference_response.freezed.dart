// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preference_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferenceResponse {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'wellness_alerts') bool get wellnessAlerts;@JsonKey(name: 'medication_reminders') bool get medicationReminders;@JsonKey(name: 'system_updates') bool get systemUpdates;
/// Create a copy of NotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferenceResponseCopyWith<NotificationPreferenceResponse> get copyWith => _$NotificationPreferenceResponseCopyWithImpl<NotificationPreferenceResponse>(this as NotificationPreferenceResponse, _$identity);

  /// Serializes this NotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wellnessAlerts, wellnessAlerts) || other.wellnessAlerts == wellnessAlerts)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.systemUpdates, systemUpdates) || other.systemUpdates == systemUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,wellnessAlerts,medicationReminders,systemUpdates);

@override
String toString() {
  return 'NotificationPreferenceResponse(userId: $userId, wellnessAlerts: $wellnessAlerts, medicationReminders: $medicationReminders, systemUpdates: $systemUpdates)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferenceResponseCopyWith<$Res>  {
  factory $NotificationPreferenceResponseCopyWith(NotificationPreferenceResponse value, $Res Function(NotificationPreferenceResponse) _then) = _$NotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'wellness_alerts') bool wellnessAlerts,@JsonKey(name: 'medication_reminders') bool medicationReminders,@JsonKey(name: 'system_updates') bool systemUpdates
});




}
/// @nodoc
class _$NotificationPreferenceResponseCopyWithImpl<$Res>
    implements $NotificationPreferenceResponseCopyWith<$Res> {
  _$NotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final NotificationPreferenceResponse _self;
  final $Res Function(NotificationPreferenceResponse) _then;

/// Create a copy of NotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? wellnessAlerts = null,Object? medicationReminders = null,Object? systemUpdates = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,wellnessAlerts: null == wellnessAlerts ? _self.wellnessAlerts : wellnessAlerts // ignore: cast_nullable_to_non_nullable
as bool,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,systemUpdates: null == systemUpdates ? _self.systemUpdates : systemUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferenceResponse].
extension NotificationPreferenceResponsePatterns on NotificationPreferenceResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferenceResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferenceResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferenceResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wellness_alerts')  bool wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool medicationReminders, @JsonKey(name: 'system_updates')  bool systemUpdates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wellness_alerts')  bool wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool medicationReminders, @JsonKey(name: 'system_updates')  bool systemUpdates)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferenceResponse():
return $default(_that.userId,_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wellness_alerts')  bool wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool medicationReminders, @JsonKey(name: 'system_updates')  bool systemUpdates)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferenceResponse implements NotificationPreferenceResponse {
  const _NotificationPreferenceResponse({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'wellness_alerts') required this.wellnessAlerts, @JsonKey(name: 'medication_reminders') required this.medicationReminders, @JsonKey(name: 'system_updates') required this.systemUpdates});
  factory _NotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$NotificationPreferenceResponseFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'wellness_alerts') final  bool wellnessAlerts;
@override@JsonKey(name: 'medication_reminders') final  bool medicationReminders;
@override@JsonKey(name: 'system_updates') final  bool systemUpdates;

/// Create a copy of NotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferenceResponseCopyWith<_NotificationPreferenceResponse> get copyWith => __$NotificationPreferenceResponseCopyWithImpl<_NotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wellnessAlerts, wellnessAlerts) || other.wellnessAlerts == wellnessAlerts)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.systemUpdates, systemUpdates) || other.systemUpdates == systemUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,wellnessAlerts,medicationReminders,systemUpdates);

@override
String toString() {
  return 'NotificationPreferenceResponse(userId: $userId, wellnessAlerts: $wellnessAlerts, medicationReminders: $medicationReminders, systemUpdates: $systemUpdates)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferenceResponseCopyWith<$Res> implements $NotificationPreferenceResponseCopyWith<$Res> {
  factory _$NotificationPreferenceResponseCopyWith(_NotificationPreferenceResponse value, $Res Function(_NotificationPreferenceResponse) _then) = __$NotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'wellness_alerts') bool wellnessAlerts,@JsonKey(name: 'medication_reminders') bool medicationReminders,@JsonKey(name: 'system_updates') bool systemUpdates
});




}
/// @nodoc
class __$NotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$NotificationPreferenceResponseCopyWith<$Res> {
  __$NotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _NotificationPreferenceResponse _self;
  final $Res Function(_NotificationPreferenceResponse) _then;

/// Create a copy of NotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? wellnessAlerts = null,Object? medicationReminders = null,Object? systemUpdates = null,}) {
  return _then(_NotificationPreferenceResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,wellnessAlerts: null == wellnessAlerts ? _self.wellnessAlerts : wellnessAlerts // ignore: cast_nullable_to_non_nullable
as bool,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,systemUpdates: null == systemUpdates ? _self.systemUpdates : systemUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
