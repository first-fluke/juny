// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogResponse {

 String get id;@JsonKey(name: 'actor_id') String? get actorId; String get action;@JsonKey(name: 'resource_type') String get resourceType; dynamic get detail; String? get description; DateTime get timestamp;
/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogResponseCopyWith<AuditLogResponse> get copyWith => _$AuditLogResponseCopyWithImpl<AuditLogResponse>(this as AuditLogResponse, _$identity);

  /// Serializes this AuditLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&const DeepCollectionEquality().equals(other.detail, detail)&&(identical(other.description, description) || other.description == description)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actorId,action,resourceType,const DeepCollectionEquality().hash(detail),description,timestamp);

@override
String toString() {
  return 'AuditLogResponse(id: $id, actorId: $actorId, action: $action, resourceType: $resourceType, detail: $detail, description: $description, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AuditLogResponseCopyWith<$Res>  {
  factory $AuditLogResponseCopyWith(AuditLogResponse value, $Res Function(AuditLogResponse) _then) = _$AuditLogResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'actor_id') String? actorId, String action,@JsonKey(name: 'resource_type') String resourceType, dynamic detail, String? description, DateTime timestamp
});




}
/// @nodoc
class _$AuditLogResponseCopyWithImpl<$Res>
    implements $AuditLogResponseCopyWith<$Res> {
  _$AuditLogResponseCopyWithImpl(this._self, this._then);

  final AuditLogResponse _self;
  final $Res Function(AuditLogResponse) _then;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? actorId = freezed,Object? action = null,Object? resourceType = null,Object? detail = freezed,Object? description = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogResponse].
extension AuditLogResponsePatterns on AuditLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'actor_id')  String? actorId,  String action, @JsonKey(name: 'resource_type')  String resourceType,  dynamic detail,  String? description,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
return $default(_that.id,_that.actorId,_that.action,_that.resourceType,_that.detail,_that.description,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'actor_id')  String? actorId,  String action, @JsonKey(name: 'resource_type')  String resourceType,  dynamic detail,  String? description,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _AuditLogResponse():
return $default(_that.id,_that.actorId,_that.action,_that.resourceType,_that.detail,_that.description,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'actor_id')  String? actorId,  String action, @JsonKey(name: 'resource_type')  String resourceType,  dynamic detail,  String? description,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
return $default(_that.id,_that.actorId,_that.action,_that.resourceType,_that.detail,_that.description,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogResponse implements AuditLogResponse {
  const _AuditLogResponse({required this.id, @JsonKey(name: 'actor_id') required this.actorId, required this.action, @JsonKey(name: 'resource_type') required this.resourceType, required this.detail, required this.description, required this.timestamp});
  factory _AuditLogResponse.fromJson(Map<String, dynamic> json) => _$AuditLogResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'actor_id') final  String? actorId;
@override final  String action;
@override@JsonKey(name: 'resource_type') final  String resourceType;
@override final  dynamic detail;
@override final  String? description;
@override final  DateTime timestamp;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogResponseCopyWith<_AuditLogResponse> get copyWith => __$AuditLogResponseCopyWithImpl<_AuditLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&const DeepCollectionEquality().equals(other.detail, detail)&&(identical(other.description, description) || other.description == description)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actorId,action,resourceType,const DeepCollectionEquality().hash(detail),description,timestamp);

@override
String toString() {
  return 'AuditLogResponse(id: $id, actorId: $actorId, action: $action, resourceType: $resourceType, detail: $detail, description: $description, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AuditLogResponseCopyWith<$Res> implements $AuditLogResponseCopyWith<$Res> {
  factory _$AuditLogResponseCopyWith(_AuditLogResponse value, $Res Function(_AuditLogResponse) _then) = __$AuditLogResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'actor_id') String? actorId, String action,@JsonKey(name: 'resource_type') String resourceType, dynamic detail, String? description, DateTime timestamp
});




}
/// @nodoc
class __$AuditLogResponseCopyWithImpl<$Res>
    implements _$AuditLogResponseCopyWith<$Res> {
  __$AuditLogResponseCopyWithImpl(this._self, this._then);

  final _AuditLogResponse _self;
  final $Res Function(_AuditLogResponse) _then;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? actorId = freezed,Object? action = null,Object? resourceType = null,Object? detail = freezed,Object? description = freezed,Object? timestamp = null,}) {
  return _then(_AuditLogResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
