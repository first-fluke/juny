// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preference_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferenceUpdate {

@JsonKey(name: 'wellness_alerts') bool? get wellnessAlerts;@JsonKey(name: 'medication_reminders') bool? get medicationReminders;@JsonKey(name: 'system_updates') bool? get systemUpdates;
/// Create a copy of NotificationPreferenceUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferenceUpdateCopyWith<NotificationPreferenceUpdate> get copyWith => _$NotificationPreferenceUpdateCopyWithImpl<NotificationPreferenceUpdate>(this as NotificationPreferenceUpdate, _$identity);

  /// Serializes this NotificationPreferenceUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferenceUpdate&&(identical(other.wellnessAlerts, wellnessAlerts) || other.wellnessAlerts == wellnessAlerts)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.systemUpdates, systemUpdates) || other.systemUpdates == systemUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wellnessAlerts,medicationReminders,systemUpdates);

@override
String toString() {
  return 'NotificationPreferenceUpdate(wellnessAlerts: $wellnessAlerts, medicationReminders: $medicationReminders, systemUpdates: $systemUpdates)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferenceUpdateCopyWith<$Res>  {
  factory $NotificationPreferenceUpdateCopyWith(NotificationPreferenceUpdate value, $Res Function(NotificationPreferenceUpdate) _then) = _$NotificationPreferenceUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'wellness_alerts') bool? wellnessAlerts,@JsonKey(name: 'medication_reminders') bool? medicationReminders,@JsonKey(name: 'system_updates') bool? systemUpdates
});




}
/// @nodoc
class _$NotificationPreferenceUpdateCopyWithImpl<$Res>
    implements $NotificationPreferenceUpdateCopyWith<$Res> {
  _$NotificationPreferenceUpdateCopyWithImpl(this._self, this._then);

  final NotificationPreferenceUpdate _self;
  final $Res Function(NotificationPreferenceUpdate) _then;

/// Create a copy of NotificationPreferenceUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wellnessAlerts = freezed,Object? medicationReminders = freezed,Object? systemUpdates = freezed,}) {
  return _then(_self.copyWith(
wellnessAlerts: freezed == wellnessAlerts ? _self.wellnessAlerts : wellnessAlerts // ignore: cast_nullable_to_non_nullable
as bool?,medicationReminders: freezed == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool?,systemUpdates: freezed == systemUpdates ? _self.systemUpdates : systemUpdates // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferenceUpdate].
extension NotificationPreferenceUpdatePatterns on NotificationPreferenceUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferenceUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferenceUpdate value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferenceUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'wellness_alerts')  bool? wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool? medicationReminders, @JsonKey(name: 'system_updates')  bool? systemUpdates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate() when $default != null:
return $default(_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'wellness_alerts')  bool? wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool? medicationReminders, @JsonKey(name: 'system_updates')  bool? systemUpdates)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate():
return $default(_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'wellness_alerts')  bool? wellnessAlerts, @JsonKey(name: 'medication_reminders')  bool? medicationReminders, @JsonKey(name: 'system_updates')  bool? systemUpdates)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferenceUpdate() when $default != null:
return $default(_that.wellnessAlerts,_that.medicationReminders,_that.systemUpdates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferenceUpdate implements NotificationPreferenceUpdate {
  const _NotificationPreferenceUpdate({@JsonKey(name: 'wellness_alerts') this.wellnessAlerts, @JsonKey(name: 'medication_reminders') this.medicationReminders, @JsonKey(name: 'system_updates') this.systemUpdates});
  factory _NotificationPreferenceUpdate.fromJson(Map<String, dynamic> json) => _$NotificationPreferenceUpdateFromJson(json);

@override@JsonKey(name: 'wellness_alerts') final  bool? wellnessAlerts;
@override@JsonKey(name: 'medication_reminders') final  bool? medicationReminders;
@override@JsonKey(name: 'system_updates') final  bool? systemUpdates;

/// Create a copy of NotificationPreferenceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferenceUpdateCopyWith<_NotificationPreferenceUpdate> get copyWith => __$NotificationPreferenceUpdateCopyWithImpl<_NotificationPreferenceUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferenceUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferenceUpdate&&(identical(other.wellnessAlerts, wellnessAlerts) || other.wellnessAlerts == wellnessAlerts)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.systemUpdates, systemUpdates) || other.systemUpdates == systemUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wellnessAlerts,medicationReminders,systemUpdates);

@override
String toString() {
  return 'NotificationPreferenceUpdate(wellnessAlerts: $wellnessAlerts, medicationReminders: $medicationReminders, systemUpdates: $systemUpdates)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferenceUpdateCopyWith<$Res> implements $NotificationPreferenceUpdateCopyWith<$Res> {
  factory _$NotificationPreferenceUpdateCopyWith(_NotificationPreferenceUpdate value, $Res Function(_NotificationPreferenceUpdate) _then) = __$NotificationPreferenceUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'wellness_alerts') bool? wellnessAlerts,@JsonKey(name: 'medication_reminders') bool? medicationReminders,@JsonKey(name: 'system_updates') bool? systemUpdates
});




}
/// @nodoc
class __$NotificationPreferenceUpdateCopyWithImpl<$Res>
    implements _$NotificationPreferenceUpdateCopyWith<$Res> {
  __$NotificationPreferenceUpdateCopyWithImpl(this._self, this._then);

  final _NotificationPreferenceUpdate _self;
  final $Res Function(_NotificationPreferenceUpdate) _then;

/// Create a copy of NotificationPreferenceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wellnessAlerts = freezed,Object? medicationReminders = freezed,Object? systemUpdates = freezed,}) {
  return _then(_NotificationPreferenceUpdate(
wellnessAlerts: freezed == wellnessAlerts ? _self.wellnessAlerts : wellnessAlerts // ignore: cast_nullable_to_non_nullable
as bool?,medicationReminders: freezed == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool?,systemUpdates: freezed == systemUpdates ? _self.systemUpdates : systemUpdates // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
