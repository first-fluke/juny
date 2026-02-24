// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationCreate {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'pill_name') String get pillName;@JsonKey(name: 'schedule_time') DateTime get scheduleTime;
/// Create a copy of MedicationCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCreateCopyWith<MedicationCreate> get copyWith => _$MedicationCreateCopyWithImpl<MedicationCreate>(this as MedicationCreate, _$identity);

  /// Serializes this MedicationCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,pillName,scheduleTime);

@override
String toString() {
  return 'MedicationCreate(hostId: $hostId, pillName: $pillName, scheduleTime: $scheduleTime)';
}


}

/// @nodoc
abstract mixin class $MedicationCreateCopyWith<$Res>  {
  factory $MedicationCreateCopyWith(MedicationCreate value, $Res Function(MedicationCreate) _then) = _$MedicationCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'pill_name') String pillName,@JsonKey(name: 'schedule_time') DateTime scheduleTime
});




}
/// @nodoc
class _$MedicationCreateCopyWithImpl<$Res>
    implements $MedicationCreateCopyWith<$Res> {
  _$MedicationCreateCopyWithImpl(this._self, this._then);

  final MedicationCreate _self;
  final $Res Function(MedicationCreate) _then;

/// Create a copy of MedicationCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? pillName = null,Object? scheduleTime = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,pillName: null == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String,scheduleTime: null == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationCreate].
extension MedicationCreatePatterns on MedicationCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationCreate value)  $default,){
final _that = this;
switch (_that) {
case _MedicationCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationCreate value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationCreate() when $default != null:
return $default(_that.hostId,_that.pillName,_that.scheduleTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime)  $default,) {final _that = this;
switch (_that) {
case _MedicationCreate():
return $default(_that.hostId,_that.pillName,_that.scheduleTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime)?  $default,) {final _that = this;
switch (_that) {
case _MedicationCreate() when $default != null:
return $default(_that.hostId,_that.pillName,_that.scheduleTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationCreate implements MedicationCreate {
  const _MedicationCreate({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'pill_name') required this.pillName, @JsonKey(name: 'schedule_time') required this.scheduleTime});
  factory _MedicationCreate.fromJson(Map<String, dynamic> json) => _$MedicationCreateFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'pill_name') final  String pillName;
@override@JsonKey(name: 'schedule_time') final  DateTime scheduleTime;

/// Create a copy of MedicationCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCreateCopyWith<_MedicationCreate> get copyWith => __$MedicationCreateCopyWithImpl<_MedicationCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,pillName,scheduleTime);

@override
String toString() {
  return 'MedicationCreate(hostId: $hostId, pillName: $pillName, scheduleTime: $scheduleTime)';
}


}

/// @nodoc
abstract mixin class _$MedicationCreateCopyWith<$Res> implements $MedicationCreateCopyWith<$Res> {
  factory _$MedicationCreateCopyWith(_MedicationCreate value, $Res Function(_MedicationCreate) _then) = __$MedicationCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'pill_name') String pillName,@JsonKey(name: 'schedule_time') DateTime scheduleTime
});




}
/// @nodoc
class __$MedicationCreateCopyWithImpl<$Res>
    implements _$MedicationCreateCopyWith<$Res> {
  __$MedicationCreateCopyWithImpl(this._self, this._then);

  final _MedicationCreate _self;
  final $Res Function(_MedicationCreate) _then;

/// Create a copy of MedicationCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? pillName = null,Object? scheduleTime = null,}) {
  return _then(_MedicationCreate(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,pillName: null == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String,scheduleTime: null == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
