// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_session_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavigationSessionCreate {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'destination_query') String get destinationQuery;@JsonKey(name: 'origin_lat') num get originLat;@JsonKey(name: 'origin_lng') num get originLng;
/// Create a copy of NavigationSessionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationSessionCreateCopyWith<NavigationSessionCreate> get copyWith => _$NavigationSessionCreateCopyWithImpl<NavigationSessionCreate>(this as NavigationSessionCreate, _$identity);

  /// Serializes this NavigationSessionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationSessionCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.destinationQuery, destinationQuery) || other.destinationQuery == destinationQuery)&&(identical(other.originLat, originLat) || other.originLat == originLat)&&(identical(other.originLng, originLng) || other.originLng == originLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,destinationQuery,originLat,originLng);

@override
String toString() {
  return 'NavigationSessionCreate(hostId: $hostId, destinationQuery: $destinationQuery, originLat: $originLat, originLng: $originLng)';
}


}

/// @nodoc
abstract mixin class $NavigationSessionCreateCopyWith<$Res>  {
  factory $NavigationSessionCreateCopyWith(NavigationSessionCreate value, $Res Function(NavigationSessionCreate) _then) = _$NavigationSessionCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'destination_query') String destinationQuery,@JsonKey(name: 'origin_lat') num originLat,@JsonKey(name: 'origin_lng') num originLng
});




}
/// @nodoc
class _$NavigationSessionCreateCopyWithImpl<$Res>
    implements $NavigationSessionCreateCopyWith<$Res> {
  _$NavigationSessionCreateCopyWithImpl(this._self, this._then);

  final NavigationSessionCreate _self;
  final $Res Function(NavigationSessionCreate) _then;

/// Create a copy of NavigationSessionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? destinationQuery = null,Object? originLat = null,Object? originLng = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,destinationQuery: null == destinationQuery ? _self.destinationQuery : destinationQuery // ignore: cast_nullable_to_non_nullable
as String,originLat: null == originLat ? _self.originLat : originLat // ignore: cast_nullable_to_non_nullable
as num,originLng: null == originLng ? _self.originLng : originLng // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [NavigationSessionCreate].
extension NavigationSessionCreatePatterns on NavigationSessionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigationSessionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigationSessionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigationSessionCreate value)  $default,){
final _that = this;
switch (_that) {
case _NavigationSessionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigationSessionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _NavigationSessionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'destination_query')  String destinationQuery, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigationSessionCreate() when $default != null:
return $default(_that.hostId,_that.destinationQuery,_that.originLat,_that.originLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'destination_query')  String destinationQuery, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng)  $default,) {final _that = this;
switch (_that) {
case _NavigationSessionCreate():
return $default(_that.hostId,_that.destinationQuery,_that.originLat,_that.originLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'destination_query')  String destinationQuery, @JsonKey(name: 'origin_lat')  num originLat, @JsonKey(name: 'origin_lng')  num originLng)?  $default,) {final _that = this;
switch (_that) {
case _NavigationSessionCreate() when $default != null:
return $default(_that.hostId,_that.destinationQuery,_that.originLat,_that.originLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigationSessionCreate implements NavigationSessionCreate {
  const _NavigationSessionCreate({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'destination_query') required this.destinationQuery, @JsonKey(name: 'origin_lat') required this.originLat, @JsonKey(name: 'origin_lng') required this.originLng});
  factory _NavigationSessionCreate.fromJson(Map<String, dynamic> json) => _$NavigationSessionCreateFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'destination_query') final  String destinationQuery;
@override@JsonKey(name: 'origin_lat') final  num originLat;
@override@JsonKey(name: 'origin_lng') final  num originLng;

/// Create a copy of NavigationSessionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigationSessionCreateCopyWith<_NavigationSessionCreate> get copyWith => __$NavigationSessionCreateCopyWithImpl<_NavigationSessionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigationSessionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigationSessionCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.destinationQuery, destinationQuery) || other.destinationQuery == destinationQuery)&&(identical(other.originLat, originLat) || other.originLat == originLat)&&(identical(other.originLng, originLng) || other.originLng == originLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,destinationQuery,originLat,originLng);

@override
String toString() {
  return 'NavigationSessionCreate(hostId: $hostId, destinationQuery: $destinationQuery, originLat: $originLat, originLng: $originLng)';
}


}

/// @nodoc
abstract mixin class _$NavigationSessionCreateCopyWith<$Res> implements $NavigationSessionCreateCopyWith<$Res> {
  factory _$NavigationSessionCreateCopyWith(_NavigationSessionCreate value, $Res Function(_NavigationSessionCreate) _then) = __$NavigationSessionCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'destination_query') String destinationQuery,@JsonKey(name: 'origin_lat') num originLat,@JsonKey(name: 'origin_lng') num originLng
});




}
/// @nodoc
class __$NavigationSessionCreateCopyWithImpl<$Res>
    implements _$NavigationSessionCreateCopyWith<$Res> {
  __$NavigationSessionCreateCopyWithImpl(this._self, this._then);

  final _NavigationSessionCreate _self;
  final $Res Function(_NavigationSessionCreate) _then;

/// Create a copy of NavigationSessionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? destinationQuery = null,Object? originLat = null,Object? originLng = null,}) {
  return _then(_NavigationSessionCreate(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,destinationQuery: null == destinationQuery ? _self.destinationQuery : destinationQuery // ignore: cast_nullable_to_non_nullable
as String,originLat: null == originLat ? _self.originLat : originLat // ignore: cast_nullable_to_non_nullable
as num,originLng: null == originLng ? _self.originLng : originLng // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
