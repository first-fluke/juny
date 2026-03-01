// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_trace_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteTraceResponse {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'session_id') String? get sessionId; List<LocationWaypointResponse> get waypoints;@JsonKey(name: 'total_distance_meters') num get totalDistanceMeters;@JsonKey(name: 'duration_seconds') num get durationSeconds;
/// Create a copy of RouteTraceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteTraceResponseCopyWith<RouteTraceResponse> get copyWith => _$RouteTraceResponseCopyWithImpl<RouteTraceResponse>(this as RouteTraceResponse, _$identity);

  /// Serializes this RouteTraceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteTraceResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.waypoints, waypoints)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,sessionId,const DeepCollectionEquality().hash(waypoints),totalDistanceMeters,durationSeconds);

@override
String toString() {
  return 'RouteTraceResponse(hostId: $hostId, sessionId: $sessionId, waypoints: $waypoints, totalDistanceMeters: $totalDistanceMeters, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $RouteTraceResponseCopyWith<$Res>  {
  factory $RouteTraceResponseCopyWith(RouteTraceResponse value, $Res Function(RouteTraceResponse) _then) = _$RouteTraceResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'session_id') String? sessionId, List<LocationWaypointResponse> waypoints,@JsonKey(name: 'total_distance_meters') num totalDistanceMeters,@JsonKey(name: 'duration_seconds') num durationSeconds
});




}
/// @nodoc
class _$RouteTraceResponseCopyWithImpl<$Res>
    implements $RouteTraceResponseCopyWith<$Res> {
  _$RouteTraceResponseCopyWithImpl(this._self, this._then);

  final RouteTraceResponse _self;
  final $Res Function(RouteTraceResponse) _then;

/// Create a copy of RouteTraceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? sessionId = freezed,Object? waypoints = null,Object? totalDistanceMeters = null,Object? durationSeconds = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,waypoints: null == waypoints ? _self.waypoints : waypoints // ignore: cast_nullable_to_non_nullable
as List<LocationWaypointResponse>,totalDistanceMeters: null == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as num,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteTraceResponse].
extension RouteTraceResponsePatterns on RouteTraceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteTraceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteTraceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteTraceResponse value)  $default,){
final _that = this;
switch (_that) {
case _RouteTraceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteTraceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RouteTraceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  List<LocationWaypointResponse> waypoints, @JsonKey(name: 'total_distance_meters')  num totalDistanceMeters, @JsonKey(name: 'duration_seconds')  num durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteTraceResponse() when $default != null:
return $default(_that.hostId,_that.sessionId,_that.waypoints,_that.totalDistanceMeters,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  List<LocationWaypointResponse> waypoints, @JsonKey(name: 'total_distance_meters')  num totalDistanceMeters, @JsonKey(name: 'duration_seconds')  num durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _RouteTraceResponse():
return $default(_that.hostId,_that.sessionId,_that.waypoints,_that.totalDistanceMeters,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'session_id')  String? sessionId,  List<LocationWaypointResponse> waypoints, @JsonKey(name: 'total_distance_meters')  num totalDistanceMeters, @JsonKey(name: 'duration_seconds')  num durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RouteTraceResponse() when $default != null:
return $default(_that.hostId,_that.sessionId,_that.waypoints,_that.totalDistanceMeters,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteTraceResponse implements RouteTraceResponse {
  const _RouteTraceResponse({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'session_id') required this.sessionId, required final  List<LocationWaypointResponse> waypoints, @JsonKey(name: 'total_distance_meters') required this.totalDistanceMeters, @JsonKey(name: 'duration_seconds') required this.durationSeconds}): _waypoints = waypoints;
  factory _RouteTraceResponse.fromJson(Map<String, dynamic> json) => _$RouteTraceResponseFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'session_id') final  String? sessionId;
 final  List<LocationWaypointResponse> _waypoints;
@override List<LocationWaypointResponse> get waypoints {
  if (_waypoints is EqualUnmodifiableListView) return _waypoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_waypoints);
}

@override@JsonKey(name: 'total_distance_meters') final  num totalDistanceMeters;
@override@JsonKey(name: 'duration_seconds') final  num durationSeconds;

/// Create a copy of RouteTraceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteTraceResponseCopyWith<_RouteTraceResponse> get copyWith => __$RouteTraceResponseCopyWithImpl<_RouteTraceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteTraceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteTraceResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other._waypoints, _waypoints)&&(identical(other.totalDistanceMeters, totalDistanceMeters) || other.totalDistanceMeters == totalDistanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,sessionId,const DeepCollectionEquality().hash(_waypoints),totalDistanceMeters,durationSeconds);

@override
String toString() {
  return 'RouteTraceResponse(hostId: $hostId, sessionId: $sessionId, waypoints: $waypoints, totalDistanceMeters: $totalDistanceMeters, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$RouteTraceResponseCopyWith<$Res> implements $RouteTraceResponseCopyWith<$Res> {
  factory _$RouteTraceResponseCopyWith(_RouteTraceResponse value, $Res Function(_RouteTraceResponse) _then) = __$RouteTraceResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'session_id') String? sessionId, List<LocationWaypointResponse> waypoints,@JsonKey(name: 'total_distance_meters') num totalDistanceMeters,@JsonKey(name: 'duration_seconds') num durationSeconds
});




}
/// @nodoc
class __$RouteTraceResponseCopyWithImpl<$Res>
    implements _$RouteTraceResponseCopyWith<$Res> {
  __$RouteTraceResponseCopyWithImpl(this._self, this._then);

  final _RouteTraceResponse _self;
  final $Res Function(_RouteTraceResponse) _then;

/// Create a copy of RouteTraceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? sessionId = freezed,Object? waypoints = null,Object? totalDistanceMeters = null,Object? durationSeconds = null,}) {
  return _then(_RouteTraceResponse(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,waypoints: null == waypoints ? _self._waypoints : waypoints // ignore: cast_nullable_to_non_nullable
as List<LocationWaypointResponse>,totalDistanceMeters: null == totalDistanceMeters ? _self.totalDistanceMeters : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
as num,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
