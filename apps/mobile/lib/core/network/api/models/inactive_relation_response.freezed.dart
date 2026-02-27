// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inactive_relation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InactiveRelationResponse {

@JsonKey(name: 'relation_id') String get relationId;@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'caregiver_id') String get caregiverId; String get role;@JsonKey(name: 'last_wellness_at') DateTime? get lastWellnessAt;@JsonKey(name: 'inactive_days') int get inactiveDays;
/// Create a copy of InactiveRelationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InactiveRelationResponseCopyWith<InactiveRelationResponse> get copyWith => _$InactiveRelationResponseCopyWithImpl<InactiveRelationResponse>(this as InactiveRelationResponse, _$identity);

  /// Serializes this InactiveRelationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InactiveRelationResponse&&(identical(other.relationId, relationId) || other.relationId == relationId)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastWellnessAt, lastWellnessAt) || other.lastWellnessAt == lastWellnessAt)&&(identical(other.inactiveDays, inactiveDays) || other.inactiveDays == inactiveDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationId,hostId,caregiverId,role,lastWellnessAt,inactiveDays);

@override
String toString() {
  return 'InactiveRelationResponse(relationId: $relationId, hostId: $hostId, caregiverId: $caregiverId, role: $role, lastWellnessAt: $lastWellnessAt, inactiveDays: $inactiveDays)';
}


}

/// @nodoc
abstract mixin class $InactiveRelationResponseCopyWith<$Res>  {
  factory $InactiveRelationResponseCopyWith(InactiveRelationResponse value, $Res Function(InactiveRelationResponse) _then) = _$InactiveRelationResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'relation_id') String relationId,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role,@JsonKey(name: 'last_wellness_at') DateTime? lastWellnessAt,@JsonKey(name: 'inactive_days') int inactiveDays
});




}
/// @nodoc
class _$InactiveRelationResponseCopyWithImpl<$Res>
    implements $InactiveRelationResponseCopyWith<$Res> {
  _$InactiveRelationResponseCopyWithImpl(this._self, this._then);

  final InactiveRelationResponse _self;
  final $Res Function(InactiveRelationResponse) _then;

/// Create a copy of InactiveRelationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relationId = null,Object? hostId = null,Object? caregiverId = null,Object? role = null,Object? lastWellnessAt = freezed,Object? inactiveDays = null,}) {
  return _then(_self.copyWith(
relationId: null == relationId ? _self.relationId : relationId // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,lastWellnessAt: freezed == lastWellnessAt ? _self.lastWellnessAt : lastWellnessAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inactiveDays: null == inactiveDays ? _self.inactiveDays : inactiveDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InactiveRelationResponse].
extension InactiveRelationResponsePatterns on InactiveRelationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InactiveRelationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InactiveRelationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InactiveRelationResponse value)  $default,){
final _that = this;
switch (_that) {
case _InactiveRelationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InactiveRelationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InactiveRelationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'relation_id')  String relationId, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'last_wellness_at')  DateTime? lastWellnessAt, @JsonKey(name: 'inactive_days')  int inactiveDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InactiveRelationResponse() when $default != null:
return $default(_that.relationId,_that.hostId,_that.caregiverId,_that.role,_that.lastWellnessAt,_that.inactiveDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'relation_id')  String relationId, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'last_wellness_at')  DateTime? lastWellnessAt, @JsonKey(name: 'inactive_days')  int inactiveDays)  $default,) {final _that = this;
switch (_that) {
case _InactiveRelationResponse():
return $default(_that.relationId,_that.hostId,_that.caregiverId,_that.role,_that.lastWellnessAt,_that.inactiveDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'relation_id')  String relationId, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'last_wellness_at')  DateTime? lastWellnessAt, @JsonKey(name: 'inactive_days')  int inactiveDays)?  $default,) {final _that = this;
switch (_that) {
case _InactiveRelationResponse() when $default != null:
return $default(_that.relationId,_that.hostId,_that.caregiverId,_that.role,_that.lastWellnessAt,_that.inactiveDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InactiveRelationResponse implements InactiveRelationResponse {
  const _InactiveRelationResponse({@JsonKey(name: 'relation_id') required this.relationId, @JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'caregiver_id') required this.caregiverId, required this.role, @JsonKey(name: 'last_wellness_at') required this.lastWellnessAt, @JsonKey(name: 'inactive_days') required this.inactiveDays});
  factory _InactiveRelationResponse.fromJson(Map<String, dynamic> json) => _$InactiveRelationResponseFromJson(json);

@override@JsonKey(name: 'relation_id') final  String relationId;
@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'caregiver_id') final  String caregiverId;
@override final  String role;
@override@JsonKey(name: 'last_wellness_at') final  DateTime? lastWellnessAt;
@override@JsonKey(name: 'inactive_days') final  int inactiveDays;

/// Create a copy of InactiveRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InactiveRelationResponseCopyWith<_InactiveRelationResponse> get copyWith => __$InactiveRelationResponseCopyWithImpl<_InactiveRelationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InactiveRelationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InactiveRelationResponse&&(identical(other.relationId, relationId) || other.relationId == relationId)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastWellnessAt, lastWellnessAt) || other.lastWellnessAt == lastWellnessAt)&&(identical(other.inactiveDays, inactiveDays) || other.inactiveDays == inactiveDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationId,hostId,caregiverId,role,lastWellnessAt,inactiveDays);

@override
String toString() {
  return 'InactiveRelationResponse(relationId: $relationId, hostId: $hostId, caregiverId: $caregiverId, role: $role, lastWellnessAt: $lastWellnessAt, inactiveDays: $inactiveDays)';
}


}

/// @nodoc
abstract mixin class _$InactiveRelationResponseCopyWith<$Res> implements $InactiveRelationResponseCopyWith<$Res> {
  factory _$InactiveRelationResponseCopyWith(_InactiveRelationResponse value, $Res Function(_InactiveRelationResponse) _then) = __$InactiveRelationResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'relation_id') String relationId,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role,@JsonKey(name: 'last_wellness_at') DateTime? lastWellnessAt,@JsonKey(name: 'inactive_days') int inactiveDays
});




}
/// @nodoc
class __$InactiveRelationResponseCopyWithImpl<$Res>
    implements _$InactiveRelationResponseCopyWith<$Res> {
  __$InactiveRelationResponseCopyWithImpl(this._self, this._then);

  final _InactiveRelationResponse _self;
  final $Res Function(_InactiveRelationResponse) _then;

/// Create a copy of InactiveRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relationId = null,Object? hostId = null,Object? caregiverId = null,Object? role = null,Object? lastWellnessAt = freezed,Object? inactiveDays = null,}) {
  return _then(_InactiveRelationResponse(
relationId: null == relationId ? _self.relationId : relationId // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,lastWellnessAt: freezed == lastWellnessAt ? _self.lastWellnessAt : lastWellnessAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inactiveDays: null == inactiveDays ? _self.inactiveDays : inactiveDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
