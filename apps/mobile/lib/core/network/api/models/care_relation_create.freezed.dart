// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_relation_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareRelationCreate {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'caregiver_id') String get caregiverId;/// Caregiver role
 String get role;
/// Create a copy of CareRelationCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareRelationCreateCopyWith<CareRelationCreate> get copyWith => _$CareRelationCreateCopyWithImpl<CareRelationCreate>(this as CareRelationCreate, _$identity);

  /// Serializes this CareRelationCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareRelationCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,caregiverId,role);

@override
String toString() {
  return 'CareRelationCreate(hostId: $hostId, caregiverId: $caregiverId, role: $role)';
}


}

/// @nodoc
abstract mixin class $CareRelationCreateCopyWith<$Res>  {
  factory $CareRelationCreateCopyWith(CareRelationCreate value, $Res Function(CareRelationCreate) _then) = _$CareRelationCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role
});




}
/// @nodoc
class _$CareRelationCreateCopyWithImpl<$Res>
    implements $CareRelationCreateCopyWith<$Res> {
  _$CareRelationCreateCopyWithImpl(this._self, this._then);

  final CareRelationCreate _self;
  final $Res Function(CareRelationCreate) _then;

/// Create a copy of CareRelationCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? caregiverId = null,Object? role = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CareRelationCreate].
extension CareRelationCreatePatterns on CareRelationCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareRelationCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareRelationCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareRelationCreate value)  $default,){
final _that = this;
switch (_that) {
case _CareRelationCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareRelationCreate value)?  $default,){
final _that = this;
switch (_that) {
case _CareRelationCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareRelationCreate() when $default != null:
return $default(_that.hostId,_that.caregiverId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role)  $default,) {final _that = this;
switch (_that) {
case _CareRelationCreate():
return $default(_that.hostId,_that.caregiverId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'caregiver_id')  String caregiverId,  String role)?  $default,) {final _that = this;
switch (_that) {
case _CareRelationCreate() when $default != null:
return $default(_that.hostId,_that.caregiverId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareRelationCreate implements CareRelationCreate {
  const _CareRelationCreate({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'caregiver_id') required this.caregiverId, required this.role});
  factory _CareRelationCreate.fromJson(Map<String, dynamic> json) => _$CareRelationCreateFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'caregiver_id') final  String caregiverId;
/// Caregiver role
@override final  String role;

/// Create a copy of CareRelationCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareRelationCreateCopyWith<_CareRelationCreate> get copyWith => __$CareRelationCreateCopyWithImpl<_CareRelationCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareRelationCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareRelationCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,caregiverId,role);

@override
String toString() {
  return 'CareRelationCreate(hostId: $hostId, caregiverId: $caregiverId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CareRelationCreateCopyWith<$Res> implements $CareRelationCreateCopyWith<$Res> {
  factory _$CareRelationCreateCopyWith(_CareRelationCreate value, $Res Function(_CareRelationCreate) _then) = __$CareRelationCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'caregiver_id') String caregiverId, String role
});




}
/// @nodoc
class __$CareRelationCreateCopyWithImpl<$Res>
    implements _$CareRelationCreateCopyWith<$Res> {
  __$CareRelationCreateCopyWithImpl(this._self, this._then);

  final _CareRelationCreate _self;
  final $Res Function(_CareRelationCreate) _then;

/// Create a copy of CareRelationCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? caregiverId = null,Object? role = null,}) {
  return _then(_CareRelationCreate(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
