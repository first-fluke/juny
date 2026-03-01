// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavigationSessionResponse {

 String get id;@JsonKey(name: 'host_id') String get hostId; String get status;@JsonKey(name: 'destination_name') String get destinationName;@JsonKey(name: 'destination_lat') num get destinationLat;@JsonKey(name: 'destination_lng') num get destinationLng;@JsonKey(name: 'origin_lat') num get originLat;@JsonKey(name: 'origin_lng') num get originLng;@JsonKey(name: 'route_data') dynamic get routeData;@JsonKey(name: 'current_step_index') int get currentStepIndex;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;
/// Create a copy of NavigationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationSessionResponseCopyWith<NavigationSessionResponse> get copyWith => _$NavigationSessionResponseCopyWithImpl<NavigationSessionResponse>(this as NavigationSessionResponse, _$identity);

  /// Serializes this NavigationSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.destinationName, destinationName) || other.destinationName == destinationName)&&(identical(other.destinationLat, destinationLat) || other.destinationLat == destinationLat)&&(identical(other.destinationLng, destinationLng) || other.destinationLng == destinationLng)&&(identical(other.originLat, originLat) || other.originLat == originLat)&&(identical(other.originLng, originLng) || other.originLng == originLng)&&const DeepCollectionEquality().equals(other.routeData, routeData)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,status,destinationName,destinationLat,destinationLng,originLat,originLng,const DeepCollectionEquality().hash(routeData),currentStepIndex,createdAt,completedAt);

@override
String toString() {
  return 'NavigationSessionResponse(id: $id, hostId: $hostId, status: $status, destinationName: $destinationName, destinationLat: $destinationLat, destinationLng: $destinationLng, originLat: $originLat, originLng: $originLng, routeData: $routeData, currentStepIndex: $currentStepIndex, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $NavigationSessionResponseCopyWith<$Res>  {
  factory $NavigationSessionResponseCopyWith(NavigationSessionResponse value, $Res Function(NavigationSessionResponse) _then) = _$NavigationSessionResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId, String status,@JsonKey(name: 'destination_name') String destinationName,@JsonKey(name: 'destination_lat') num destinationLat,@JsonKey(name: 'destination_lng') num destinationLng,@JsonKey(name: 'origin_lat') num originLat,@JsonKey(name: 'origin_lng') num originLng,@JsonKey(name: 'route_data') dynamic routeData,@JsonKey(name: 'current_step_index') int currentStepIndex,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'completed_at') DateTime? completedAt
});




}
/// @nodoc
class _$NavigationSessionResponseCopyWithImpl<$Res>
    implements $NavigationSessionResponseCopyWith<$Res> {
  _$NavigationSessionResponseCopyWithImpl(this._self, this._then);

  final NavigationSessionResponse _self;
  final $Res Function(NavigationSessionResponse) _then;

/// Create a copy of NavigationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? status = null,Object? destinationName = null,Object? destinationLat = null,Object? destinationLng = null,Object? originLat = null,Object? originLng = null,Object? routeData = freezed,Object? currentStepIndex = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,destinationName: null == destinationName ? _self.destinationName : destinationName // ignore: cast_nullable_to_non_nullable
as String,destinationLat: null == destinationLat ? _self.destinationLat : destinationLat // ignore: cast_nullable_to_non_nullable
as num,destinationLng: null == destinationLng ? _self.destinationLng : destinationLng // ignore: cast_nullable_to_non_nullable
as num,originLat: null == originLat ? _self.originLat : originLat // ignore: cast_nullable_to_non_nullable
as num,originLng: null == originLng ? _self.originLng : originLng // ignore: cast_nullable_to_non_nullable
as num,routeData: freezed == routeData ? _self.routeData : routeData // ignore: cast_nullable_to_non_nullable
as dynamic,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavigationSessionResponse].
extension NavigationSessionResponsePatterns on NavigationSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigationSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigationSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigationSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _NavigationSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigationSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NavigationSessionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status, @JsonKey(name: 'destination_name')  String destinationName, @JsonKey(name: 'destination_lat')  num destinationLat, @JsonKey(name: 'destination_lng')  num destinationLng, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng, @JsonKey(name: 'route_data')  dynamic routeData, @JsonKey(name: 'current_step_index')  int currentStepIndex, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigationSessionResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.status,_that.destinationName,_that.destinationLat,_that.destinationLng,_that.originLat,_that.originLng,_that.routeData,_that.currentStepIndex,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status, @JsonKey(name: 'destination_name')  String destinationName, @JsonKey(name: 'destination_lat')  num destinationLat, @JsonKey(name: 'destination_lng')  num destinationLng, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng, @JsonKey(name: 'route_data')  dynamic routeData, @JsonKey(name: 'current_step_index')  int currentStepIndex, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _NavigationSessionResponse():
return $default(_that.id,_that.hostId,_that.status,_that.destinationName,_that.destinationLat,_that.destinationLng,_that.originLat,_that.originLng,_that.routeData,_that.currentStepIndex,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'host_id')  String hostId,  String status, @JsonKey(name: 'destination_name')  String destinationName, @JsonKey(name: 'destination_lat')  num destinationLat, @JsonKey(name: 'destination_lng')  num destinationLng, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng, @JsonKey(name: 'route_data')  dynamic routeData, @JsonKey(name: 'current_step_index')  int currentStepIndex, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'completed_at')  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _NavigationSessionResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.status,_that.destinationName,_that.destinationLat,_that.destinationLng,_that.originLat,_that.originLng,_that.routeData,_that.currentStepIndex,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigationSessionResponse implements NavigationSessionResponse {
  const _NavigationSessionResponse({required this.id, @JsonKey(name: 'host_id') required this.hostId, required this.status, @JsonKey(name: 'destination_name') required this.destinationName, @JsonKey(name: 'destination_lat') required this.destinationLat, @JsonKey(name: 'destination_lng') required this.destinationLng, @JsonKey(name: 'origin_lat') required this.originLat, @JsonKey(name: 'origin_lng') required this.originLng, @JsonKey(name: 'route_data') required this.routeData, @JsonKey(name: 'current_step_index') required this.currentStepIndex, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'completed_at') required this.completedAt});
  factory _NavigationSessionResponse.fromJson(Map<String, dynamic> json) => _$NavigationSessionResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'host_id') final  String hostId;
@override final  String status;
@override@JsonKey(name: 'destination_name') final  String destinationName;
@override@JsonKey(name: 'destination_lat') final  num destinationLat;
@override@JsonKey(name: 'destination_lng') final  num destinationLng;
@override@JsonKey(name: 'origin_lat') final  num originLat;
@override@JsonKey(name: 'origin_lng') final  num originLng;
@override@JsonKey(name: 'route_data') final  dynamic routeData;
@override@JsonKey(name: 'current_step_index') final  int currentStepIndex;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;

/// Create a copy of NavigationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigationSessionResponseCopyWith<_NavigationSessionResponse> get copyWith => __$NavigationSessionResponseCopyWithImpl<_NavigationSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigationSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigationSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.destinationName, destinationName) || other.destinationName == destinationName)&&(identical(other.destinationLat, destinationLat) || other.destinationLat == destinationLat)&&(identical(other.destinationLng, destinationLng) || other.destinationLng == destinationLng)&&(identical(other.originLat, originLat) || other.originLat == originLat)&&(identical(other.originLng, originLng) || other.originLng == originLng)&&const DeepCollectionEquality().equals(other.routeData, routeData)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,status,destinationName,destinationLat,destinationLng,originLat,originLng,const DeepCollectionEquality().hash(routeData),currentStepIndex,createdAt,completedAt);

@override
String toString() {
  return 'NavigationSessionResponse(id: $id, hostId: $hostId, status: $status, destinationName: $destinationName, destinationLat: $destinationLat, destinationLng: $destinationLng, originLat: $originLat, originLng: $originLng, routeData: $routeData, currentStepIndex: $currentStepIndex, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$NavigationSessionResponseCopyWith<$Res> implements $NavigationSessionResponseCopyWith<$Res> {
  factory _$NavigationSessionResponseCopyWith(_NavigationSessionResponse value, $Res Function(_NavigationSessionResponse) _then) = __$NavigationSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId, String status,@JsonKey(name: 'destination_name') String destinationName,@JsonKey(name: 'destination_lat') num destinationLat,@JsonKey(name: 'destination_lng') num destinationLng,@JsonKey(name: 'origin_lat') num originLat,@JsonKey(name: 'origin_lng') num originLng,@JsonKey(name: 'route_data') dynamic routeData,@JsonKey(name: 'current_step_index') int currentStepIndex,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'completed_at') DateTime? completedAt
});




}
/// @nodoc
class __$NavigationSessionResponseCopyWithImpl<$Res>
    implements _$NavigationSessionResponseCopyWith<$Res> {
  __$NavigationSessionResponseCopyWithImpl(this._self, this._then);

  final _NavigationSessionResponse _self;
  final $Res Function(_NavigationSessionResponse) _then;

/// Create a copy of NavigationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? status = null,Object? destinationName = null,Object? destinationLat = null,Object? destinationLng = null,Object? originLat = null,Object? originLng = null,Object? routeData = freezed,Object? currentStepIndex = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_NavigationSessionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,destinationName: null == destinationName ? _self.destinationName : destinationName // ignore: cast_nullable_to_non_nullable
as String,destinationLat: null == destinationLat ? _self.destinationLat : destinationLat // ignore: cast_nullable_to_non_nullable
as num,destinationLng: null == destinationLng ? _self.destinationLng : destinationLng // ignore: cast_nullable_to_non_nullable
as num,originLat: null == originLat ? _self.originLat : originLat // ignore: cast_nullable_to_non_nullable
as num,originLng: null == originLng ? _self.originLng : originLng // ignore: cast_nullable_to_non_nullable
as num,routeData: freezed == routeData ? _self.routeData : routeData // ignore: cast_nullable_to_non_nullable
as dynamic,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
