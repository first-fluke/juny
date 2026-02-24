// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_relation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareRelationResponse {

 String get id;@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'caregiver_id') String get caregiverId; String get role;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of CareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareRelationResponseCopyWith<CareRelationResponse> get copyWith => _$CareRelationResponseCopyWithImpl<CareRelationResponse>(this as CareRelationResponse, _$identity);

  /// Serializes this CareRelationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareRelationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,caregiverId,role,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'CareRelationResponse(id: $id, hostId: $hostId, caregiverId: $caregiverId, role: $role, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CareRelationResponseCopyWith<$Res>  {
  factory $CareRelationResponseCopyWith(CareRelationResponse value, $Res Function(CareRelationResponse) _then) = _$CareRelationResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$CareRelationResponseCopyWithImpl<$Res>
    implements $CareRelationResponseCopyWith<$Res> {
  _$CareRelationResponseCopyWithImpl(this._self, this._then);

  final CareRelationResponse _self;
  final $Res Function(CareRelationResponse) _then;

/// Create a copy of CareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? caregiverId = null,Object? role = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareRelationResponse].
extension CareRelationResponsePatterns on CareRelationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareRelationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareRelationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareRelationResponse value)  $default,){
final _that = this;
switch (_that) {
case _CareRelationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareRelationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CareRelationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareRelationResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.caregiverId,_that.role,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CareRelationResponse():
return $default(_that.id,_that.hostId,_that.caregiverId,_that.role,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CareRelationResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.caregiverId,_that.role,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareRelationResponse implements CareRelationResponse {
  const _CareRelationResponse({required this.id, @JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'caregiver_id') required this.caregiverId, required this.role, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _CareRelationResponse.fromJson(Map<String, dynamic> json) => _$CareRelationResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'caregiver_id') final  String caregiverId;
@override final  String role;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of CareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareRelationResponseCopyWith<_CareRelationResponse> get copyWith => __$CareRelationResponseCopyWithImpl<_CareRelationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareRelationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareRelationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,caregiverId,role,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'CareRelationResponse(id: $id, hostId: $hostId, caregiverId: $caregiverId, role: $role, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CareRelationResponseCopyWith<$Res> implements $CareRelationResponseCopyWith<$Res> {
  factory _$CareRelationResponseCopyWith(_CareRelationResponse value, $Res Function(_CareRelationResponse) _then) = __$CareRelationResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$CareRelationResponseCopyWithImpl<$Res>
    implements _$CareRelationResponseCopyWith<$Res> {
  __$CareRelationResponseCopyWithImpl(this._self, this._then);

  final _CareRelationResponse _self;
  final $Res Function(_CareRelationResponse) _then;

/// Create a copy of CareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? caregiverId = null,Object? role = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_CareRelationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
