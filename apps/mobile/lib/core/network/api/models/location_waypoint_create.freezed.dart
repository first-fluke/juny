// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_waypoint_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationWaypointCreate {

@JsonKey(name: 'host_id') String get hostId; num get lat; num get lng;@JsonKey(name: 'session_id') String? get sessionId; num? get altitude; num? get accuracy; num? get speed; num? get heading;
/// Create a copy of LocationWaypointCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationWaypointCreateCopyWith<LocationWaypointCreate> get copyWith => _$LocationWaypointCreateCopyWithImpl<LocationWaypointCreate>(this as LocationWaypointCreate, _$identity);

  /// Serializes this LocationWaypointCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationWaypointCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,lat,lng,sessionId,altitude,accuracy,speed,heading);

@override
String toString() {
  return 'LocationWaypointCreate(hostId: $hostId, lat: $lat, lng: $lng, sessionId: $sessionId, altitude: $altitude, accuracy: $accuracy, speed: $speed, heading: $heading)';
}


}

/// @nodoc
abstract mixin class $LocationWaypointCreateCopyWith<$Res>  {
  factory $LocationWaypointCreateCopyWith(LocationWaypointCreate value, $Res Function(LocationWaypointCreate) _then) = _$LocationWaypointCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, num lat, num lng,@JsonKey(name: 'session_id') String? sessionId, num? altitude, num? accuracy, num? speed, num? heading
});




}
/// @nodoc
class _$LocationWaypointCreateCopyWithImpl<$Res>
    implements $LocationWaypointCreateCopyWith<$Res> {
  _$LocationWaypointCreateCopyWithImpl(this._self, this._then);

  final LocationWaypointCreate _self;
  final $Res Function(LocationWaypointCreate) _then;

/// Create a copy of LocationWaypointCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? lat = null,Object? lng = null,Object? sessionId = freezed,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? heading = freezed,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as num,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as num,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as num?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as num?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as num?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationWaypointCreate].
extension LocationWaypointCreatePatterns on LocationWaypointCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationWaypointCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationWaypointCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationWaypointCreate value)  $default,){
final _that = this;
switch (_that) {
case _LocationWaypointCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationWaypointCreate value)?  $default,){
final _that = this;
switch (_that) {
case _LocationWaypointCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  num lat,  num lng, @JsonKey(name: 'session_id')  String? sessionId,  num? altitude,  num? accuracy,  num? speed,  num? heading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationWaypointCreate() when $default != null:
return $default(_that.hostId,_that.lat,_that.lng,_that.sessionId,_that.altitude,_that.accuracy,_that.speed,_that.heading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  num lat,  num lng, @JsonKey(name: 'session_id')  String? sessionId,  num? altitude,  num? accuracy,  num? speed,  num? heading)  $default,) {final _that = this;
switch (_that) {
case _LocationWaypointCreate():
return $default(_that.hostId,_that.lat,_that.lng,_that.sessionId,_that.altitude,_that.accuracy,_that.speed,_that.heading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId,  num lat,  num lng, @JsonKey(name: 'session_id')  String? sessionId,  num? altitude,  num? accuracy,  num? speed,  num? heading)?  $default,) {final _that = this;
switch (_that) {
case _LocationWaypointCreate() when $default != null:
return $default(_that.hostId,_that.lat,_that.lng,_that.sessionId,_that.altitude,_that.accuracy,_that.speed,_that.heading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationWaypointCreate implements LocationWaypointCreate {
  const _LocationWaypointCreate({@JsonKey(name: 'host_id') required this.hostId, required this.lat, required this.lng, @JsonKey(name: 'session_id') this.sessionId, this.altitude, this.accuracy, this.speed, this.heading});
  factory _LocationWaypointCreate.fromJson(Map<String, dynamic> json) => _$LocationWaypointCreateFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override final  num lat;
@override final  num lng;
@override@JsonKey(name: 'session_id') final  String? sessionId;
@override final  num? altitude;
@override final  num? accuracy;
@override final  num? speed;
@override final  num? heading;

/// Create a copy of LocationWaypointCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationWaypointCreateCopyWith<_LocationWaypointCreate> get copyWith => __$LocationWaypointCreateCopyWithImpl<_LocationWaypointCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationWaypointCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationWaypointCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,lat,lng,sessionId,altitude,accuracy,speed,heading);

@override
String toString() {
  return 'LocationWaypointCreate(hostId: $hostId, lat: $lat, lng: $lng, sessionId: $sessionId, altitude: $altitude, accuracy: $accuracy, speed: $speed, heading: $heading)';
}


}

/// @nodoc
abstract mixin class _$LocationWaypointCreateCopyWith<$Res> implements $LocationWaypointCreateCopyWith<$Res> {
  factory _$LocationWaypointCreateCopyWith(_LocationWaypointCreate value, $Res Function(_LocationWaypointCreate) _then) = __$LocationWaypointCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, num lat, num lng,@JsonKey(name: 'session_id') String? sessionId, num? altitude, num? accuracy, num? speed, num? heading
});




}
/// @nodoc
class __$LocationWaypointCreateCopyWithImpl<$Res>
    implements _$LocationWaypointCreateCopyWith<$Res> {
  __$LocationWaypointCreateCopyWithImpl(this._self, this._then);

  final _LocationWaypointCreate _self;
  final $Res Function(_LocationWaypointCreate) _then;

/// Create a copy of LocationWaypointCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? lat = null,Object? lng = null,Object? sessionId = freezed,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? heading = freezed,}) {
  return _then(_LocationWaypointCreate(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as num,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as num,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as num?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as num?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as num?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
