// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationResponse {

 String get id;@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'pill_name') String get pillName;@JsonKey(name: 'schedule_time') DateTime get scheduleTime;@JsonKey(name: 'is_taken') bool get isTaken;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'taken_at') DateTime? get takenAt;
/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationResponseCopyWith<MedicationResponse> get copyWith => _$MedicationResponseCopyWithImpl<MedicationResponse>(this as MedicationResponse, _$identity);

  /// Serializes this MedicationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,pillName,scheduleTime,isTaken,createdAt,takenAt);

@override
String toString() {
  return 'MedicationResponse(id: $id, hostId: $hostId, pillName: $pillName, scheduleTime: $scheduleTime, isTaken: $isTaken, createdAt: $createdAt, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class $MedicationResponseCopyWith<$Res>  {
  factory $MedicationResponseCopyWith(MedicationResponse value, $Res Function(MedicationResponse) _then) = _$MedicationResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'pill_name') String pillName,@JsonKey(name: 'schedule_time') DateTime scheduleTime,@JsonKey(name: 'is_taken') bool isTaken,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'taken_at') DateTime? takenAt
});




}
/// @nodoc
class _$MedicationResponseCopyWithImpl<$Res>
    implements $MedicationResponseCopyWith<$Res> {
  _$MedicationResponseCopyWithImpl(this._self, this._then);

  final MedicationResponse _self;
  final $Res Function(MedicationResponse) _then;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? pillName = null,Object? scheduleTime = null,Object? isTaken = null,Object? createdAt = null,Object? takenAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,pillName: null == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String,scheduleTime: null == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime,isTaken: null == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationResponse].
extension MedicationResponsePatterns on MedicationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationResponse value)  $default,){
final _that = this;
switch (_that) {
case _MedicationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime, @JsonKey(name: 'is_taken')  bool isTaken, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'taken_at')  DateTime? takenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.pillName,_that.scheduleTime,_that.isTaken,_that.createdAt,_that.takenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime, @JsonKey(name: 'is_taken')  bool isTaken, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'taken_at')  DateTime? takenAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationResponse():
return $default(_that.id,_that.hostId,_that.pillName,_that.scheduleTime,_that.isTaken,_that.createdAt,_that.takenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'pill_name')  String pillName, @JsonKey(name: 'schedule_time')  DateTime scheduleTime, @JsonKey(name: 'is_taken')  bool isTaken, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'taken_at')  DateTime? takenAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.pillName,_that.scheduleTime,_that.isTaken,_that.createdAt,_that.takenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationResponse implements MedicationResponse {
  const _MedicationResponse({required this.id, @JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'pill_name') required this.pillName, @JsonKey(name: 'schedule_time') required this.scheduleTime, @JsonKey(name: 'is_taken') required this.isTaken, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'taken_at') this.takenAt});
  factory _MedicationResponse.fromJson(Map<String, dynamic> json) => _$MedicationResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'pill_name') final  String pillName;
@override@JsonKey(name: 'schedule_time') final  DateTime scheduleTime;
@override@JsonKey(name: 'is_taken') final  bool isTaken;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'taken_at') final  DateTime? takenAt;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationResponseCopyWith<_MedicationResponse> get copyWith => __$MedicationResponseCopyWithImpl<_MedicationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.pillName, pillName) || other.pillName == pillName)&&(identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,pillName,scheduleTime,isTaken,createdAt,takenAt);

@override
String toString() {
  return 'MedicationResponse(id: $id, hostId: $hostId, pillName: $pillName, scheduleTime: $scheduleTime, isTaken: $isTaken, createdAt: $createdAt, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationResponseCopyWith<$Res> implements $MedicationResponseCopyWith<$Res> {
  factory _$MedicationResponseCopyWith(_MedicationResponse value, $Res Function(_MedicationResponse) _then) = __$MedicationResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'pill_name') String pillName,@JsonKey(name: 'schedule_time') DateTime scheduleTime,@JsonKey(name: 'is_taken') bool isTaken,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'taken_at') DateTime? takenAt
});




}
/// @nodoc
class __$MedicationResponseCopyWithImpl<$Res>
    implements _$MedicationResponseCopyWith<$Res> {
  __$MedicationResponseCopyWithImpl(this._self, this._then);

  final _MedicationResponse _self;
  final $Res Function(_MedicationResponse) _then;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? pillName = null,Object? scheduleTime = null,Object? isTaken = null,Object? createdAt = null,Object? takenAt = freezed,}) {
  return _then(_MedicationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,pillName: null == pillName ? _self.pillName : pillName // ignore: cast_nullable_to_non_nullable
as String,scheduleTime: null == scheduleTime ? _self.scheduleTime : scheduleTime // ignore: cast_nullable_to_non_nullable
as DateTime,isTaken: null == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
