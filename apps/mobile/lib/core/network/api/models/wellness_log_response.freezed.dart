// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wellness_log_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WellnessLogResponse {

 String get id;@JsonKey(name: 'host_id') String get hostId; String get status; String get summary; dynamic get details;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of WellnessLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessLogResponseCopyWith<WellnessLogResponse> get copyWith => _$WellnessLogResponseCopyWithImpl<WellnessLogResponse>(this as WellnessLogResponse, _$identity);

  /// Serializes this WellnessLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,status,summary,const DeepCollectionEquality().hash(details),createdAt);

@override
String toString() {
  return 'WellnessLogResponse(id: $id, hostId: $hostId, status: $status, summary: $summary, details: $details, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WellnessLogResponseCopyWith<$Res>  {
  factory $WellnessLogResponseCopyWith(WellnessLogResponse value, $Res Function(WellnessLogResponse) _then) = _$WellnessLogResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId, String status, String summary, dynamic details,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$WellnessLogResponseCopyWithImpl<$Res>
    implements $WellnessLogResponseCopyWith<$Res> {
  _$WellnessLogResponseCopyWithImpl(this._self, this._then);

  final WellnessLogResponse _self;
  final $Res Function(WellnessLogResponse) _then;

/// Create a copy of WellnessLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? status = null,Object? summary = null,Object? details = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessLogResponse].
extension WellnessLogResponsePatterns on WellnessLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _WellnessLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status,  String summary,  dynamic details, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessLogResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.status,_that.summary,_that.details,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status,  String summary,  dynamic details, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WellnessLogResponse():
return $default(_that.id,_that.hostId,_that.status,_that.summary,_that.details,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status,  String summary,  dynamic details, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WellnessLogResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.status,_that.summary,_that.details,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessLogResponse implements WellnessLogResponse {
  const _WellnessLogResponse({required this.id, @JsonKey(name: 'host_id') required this.hostId, required this.status, required this.summary, required this.details, @JsonKey(name: 'created_at') required this.createdAt});
  factory _WellnessLogResponse.fromJson(Map<String, dynamic> json) => _$WellnessLogResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'host_id') final  String hostId;
@override final  String status;
@override final  String summary;
@override final  dynamic details;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of WellnessLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessLogResponseCopyWith<_WellnessLogResponse> get copyWith => __$WellnessLogResponseCopyWithImpl<_WellnessLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,status,summary,const DeepCollectionEquality().hash(details),createdAt);

@override
String toString() {
  return 'WellnessLogResponse(id: $id, hostId: $hostId, status: $status, summary: $summary, details: $details, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WellnessLogResponseCopyWith<$Res> implements $WellnessLogResponseCopyWith<$Res> {
  factory _$WellnessLogResponseCopyWith(_WellnessLogResponse value, $Res Function(_WellnessLogResponse) _then) = __$WellnessLogResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId, String status, String summary, dynamic details,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$WellnessLogResponseCopyWithImpl<$Res>
    implements _$WellnessLogResponseCopyWith<$Res> {
  __$WellnessLogResponseCopyWithImpl(this._self, this._then);

  final _WellnessLogResponse _self;
  final $Res Function(_WellnessLogResponse) _then;

/// Create a copy of WellnessLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? status = null,Object? summary = null,Object? details = freezed,Object? createdAt = null,}) {
  return _then(_WellnessLogResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
