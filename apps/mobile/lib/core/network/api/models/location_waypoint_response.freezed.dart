// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_waypoint_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationWaypointResponse {

 String get id;@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'session_id') String? get sessionId; num get lat; num get lng; num? get altitude; num? get accuracy; num? get speed; num? get heading;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of LocationWaypointResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationWaypointResponseCopyWith<LocationWaypointResponse> get copyWith => _$LocationWaypointResponseCopyWithImpl<LocationWaypointResponse>(this as LocationWaypointResponse, _$identity);

  /// Serializes this LocationWaypointResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationWaypointResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,sessionId,lat,lng,altitude,accuracy,speed,heading,createdAt);

@override
String toString() {
  return 'LocationWaypointResponse(id: $id, hostId: $hostId, sessionId: $sessionId, lat: $lat, lng: $lng, altitude: $altitude, accuracy: $accuracy, speed: $speed, heading: $heading, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LocationWaypointResponseCopyWith<$Res>  {
  factory $LocationWaypointResponseCopyWith(LocationWaypointResponse value, $Res Function(LocationWaypointResponse) _then) = _$LocationWaypointResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'session_id') String? sessionId, num lat, num lng, num? altitude, num? accuracy, num? speed, num? heading,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$LocationWaypointResponseCopyWithImpl<$Res>
    implements $LocationWaypointResponseCopyWith<$Res> {
  _$LocationWaypointResponseCopyWithImpl(this._self, this._then);

  final LocationWaypointResponse _self;
  final $Res Function(LocationWaypointResponse) _then;

/// Create a copy of LocationWaypointResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? sessionId = freezed,Object? lat = null,Object? lng = null,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? heading = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as num,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as num,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as num?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as num?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as num?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as num?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationWaypointResponse].
extension LocationWaypointResponsePatterns on LocationWaypointResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationWaypointResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationWaypointResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationWaypointResponse value)  $default,){
final _that = this;
switch (_that) {
case _LocationWaypointResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationWaypointResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LocationWaypointResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  num lat,  num lng,  num? altitude,  num? accuracy,  num? speed,  num? heading, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationWaypointResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.sessionId,_that.lat,_that.lng,_that.altitude,_that.accuracy,_that.speed,_that.heading,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  num lat,  num lng,  num? altitude,  num? accuracy,  num? speed,  num? heading, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LocationWaypointResponse():
return $default(_that.id,_that.hostId,_that.sessionId,_that.lat,_that.lng,_that.altitude,_that.accuracy,_that.speed,_that.heading,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  num lat,  num lng,  num? altitude,  num? accuracy,  num? speed,  num? heading, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LocationWaypointResponse() when $default != null:
return $default(_that.id,_that.hostId,_that.sessionId,_that.lat,_that.lng,_that.altitude,_that.accuracy,_that.speed,_that.heading,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationWaypointResponse implements LocationWaypointResponse {
  const _LocationWaypointResponse({required this.id, @JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'session_id') required this.sessionId, required this.lat, required this.lng, required this.altitude, required this.accuracy, required this.speed, required this.heading, @JsonKey(name: 'created_at') required this.createdAt});
  factory _LocationWaypointResponse.fromJson(Map<String, dynamic> json) => _$LocationWaypointResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'session_id') final  String? sessionId;
@override final  num lat;
@override final  num lng;
@override final  num? altitude;
@override final  num? accuracy;
@override final  num? speed;
@override final  num? heading;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of LocationWaypointResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationWaypointResponseCopyWith<_LocationWaypointResponse> get copyWith => __$LocationWaypointResponseCopyWithImpl<_LocationWaypointResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationWaypointResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationWaypointResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,sessionId,lat,lng,altitude,accuracy,speed,heading,createdAt);

@override
String toString() {
  return 'LocationWaypointResponse(id: $id, hostId: $hostId, sessionId: $sessionId, lat: $lat, lng: $lng, altitude: $altitude, accuracy: $accuracy, speed: $speed, heading: $heading, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LocationWaypointResponseCopyWith<$Res> implements $LocationWaypointResponseCopyWith<$Res> {
  factory _$LocationWaypointResponseCopyWith(_LocationWaypointResponse value, $Res Function(_LocationWaypointResponse) _then) = __$LocationWaypointResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'session_id') String? sessionId, num lat, num lng, num? altitude, num? accuracy, num? speed, num? heading,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$LocationWaypointResponseCopyWithImpl<$Res>
    implements _$LocationWaypointResponseCopyWith<$Res> {
  __$LocationWaypointResponseCopyWithImpl(this._self, this._then);

  final _LocationWaypointResponse _self;
  final $Res Function(_LocationWaypointResponse) _then;

/// Create a copy of LocationWaypointResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? sessionId = freezed,Object? lat = null,Object? lng = null,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? heading = freezed,Object? createdAt = null,}) {
  return _then(_LocationWaypointResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as num,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as num,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as num?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as num?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as num?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as num?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
