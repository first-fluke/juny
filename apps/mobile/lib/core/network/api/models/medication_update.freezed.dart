// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationUpdate {

@JsonKey(name: 'pill_name') String? get pillName;@JsonKey(name: 'schedule_time') DateTime? get scheduleTime;@JsonKey(name: 'is_taken') bool? get isTaken;
/// Create a copy of MedicationUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationUpdateCopyWith<MedicationUpdate> get copyWith => _$MedicationUpdateCopyWithImpl<MedicationUpdate>(this as MedicationUpdate, _$identity);

  /// Serializes this MedicationUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationUpdate&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillName,scheduleTime,isTaken);

@override
String toString() {
  return 'MedicationUpdate(pillName: $pillName, scheduleTime: $scheduleTime, isTaken: $isTaken)';
}


}

/// @nodoc
abstract mixin class $MedicationUpdateCopyWith<$Res>  {
  factory $MedicationUpdateCopyWith(MedicationUpdate value, $Res Function(MedicationUpdate) _then) = _$MedicationUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'pill_name') String? pillName,@JsonKey(name: 'schedule_time') DateTime? scheduleTime,@JsonKey(name: 'is_taken') bool? isTaken
});




}
/// @nodoc
class _$MedicationUpdateCopyWithImpl<$Res>
    implements $MedicationUpdateCopyWith<$Res> {
  _$MedicationUpdateCopyWithImpl(this._self, this._then);

  final MedicationUpdate _self;
  final $Res Function(MedicationUpdate) _then;

/// Create a copy of MedicationUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillName = freezed,Object? scheduleTime = freezed,Object? isTaken = freezed,}) {
  return _then(_self.copyWith(
pillName: freezed == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String?,scheduleTime: freezed == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isTaken: freezed == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationUpdate].
extension MedicationUpdatePatterns on MedicationUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationUpdate value)  $default,){
final _that = this;
switch (_that) {
case _MedicationUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'pill_name')  String? pillName, @JsonKey(name: 'schedule_time')  DateTime? scheduleTime, @JsonKey(name: 'is_taken')  bool? isTaken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationUpdate() when $default != null:
return $default(_that.pillName,_that.scheduleTime,_that.isTaken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'pill_name')  String? pillName, @JsonKey(name: 'schedule_time')  DateTime? scheduleTime, @JsonKey(name: 'is_taken')  bool? isTaken)  $default,) {final _that = this;
switch (_that) {
case _MedicationUpdate():
return $default(_that.pillName,_that.scheduleTime,_that.isTaken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'pill_name')  String? pillName, @JsonKey(name: 'schedule_time')  DateTime? scheduleTime, @JsonKey(name: 'is_taken')  bool? isTaken)?  $default,) {final _that = this;
switch (_that) {
case _MedicationUpdate() when $default != null:
return $default(_that.pillName,_that.scheduleTime,_that.isTaken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationUpdate implements MedicationUpdate {
  const _MedicationUpdate({@JsonKey(name: 'pill_name') this.pillName, @JsonKey(name: 'schedule_time') this.scheduleTime, @JsonKey(name: 'is_taken') this.isTaken});
  factory _MedicationUpdate.fromJson(Map<String, dynamic> json) => _$MedicationUpdateFromJson(json);

@override@JsonKey(name: 'pill_name') final  String? pillName;
@override@JsonKey(name: 'schedule_time') final  DateTime? scheduleTime;
@override@JsonKey(name: 'is_taken') final  bool? isTaken;

/// Create a copy of MedicationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationUpdateCopyWith<_MedicationUpdate> get copyWith => __$MedicationUpdateCopyWithImpl<_MedicationUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationUpdate&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillName,scheduleTime,isTaken);

@override
String toString() {
  return 'MedicationUpdate(pillName: $pillName, scheduleTime: $scheduleTime, isTaken: $isTaken)';
}


}

/// @nodoc
abstract mixin class _$MedicationUpdateCopyWith<$Res> implements $MedicationUpdateCopyWith<$Res> {
  factory _$MedicationUpdateCopyWith(_MedicationUpdate value, $Res Function(_MedicationUpdate) _then) = __$MedicationUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'pill_name') String? pillName,@JsonKey(name: 'schedule_time') DateTime? scheduleTime,@JsonKey(name: 'is_taken') bool? isTaken
});




}
/// @nodoc
class __$MedicationUpdateCopyWithImpl<$Res>
    implements _$MedicationUpdateCopyWith<$Res> {
  __$MedicationUpdateCopyWithImpl(this._self, this._then);

  final _MedicationUpdate _self;
  final $Res Function(_MedicationUpdate) _then;

/// Create a copy of MedicationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillName = freezed,Object? scheduleTime = freezed,Object? isTaken = freezed,}) {
  return _then(_MedicationUpdate(
pillName: freezed == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String?,scheduleTime: freezed == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isTaken: freezed == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
