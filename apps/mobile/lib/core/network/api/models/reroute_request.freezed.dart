// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reroute_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RerouteRequest {

@JsonKey(name: 'current_lat') num get currentLat;@JsonKey(name: 'current_lng') num get currentLng;
/// Create a copy of RerouteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RerouteRequestCopyWith<RerouteRequest> get copyWith => _$RerouteRequestCopyWithImpl<RerouteRequest>(this as RerouteRequest, _$identity);

  /// Serializes this RerouteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RerouteRequest&&(identical(other.currentLat, currentLat) || other.currentLat == currentLat)&&(identical(other.currentLng, currentLng) || other.currentLng == currentLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentLat,currentLng);

@override
String toString() {
  return 'RerouteRequest(currentLat: $currentLat, currentLng: $currentLng)';
}


}

/// @nodoc
abstract mixin class $RerouteRequestCopyWith<$Res>  {
  factory $RerouteRequestCopyWith(RerouteRequest value, $Res Function(RerouteRequest) _then) = _$RerouteRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_lat') num currentLat,@JsonKey(name: 'current_lng') num currentLng
});




}
/// @nodoc
class _$RerouteRequestCopyWithImpl<$Res>
    implements $RerouteRequestCopyWith<$Res> {
  _$RerouteRequestCopyWithImpl(this._self, this._then);

  final RerouteRequest _self;
  final $Res Function(RerouteRequest) _then;

/// Create a copy of RerouteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentLat = null,Object? currentLng = null,}) {
  return _then(_self.copyWith(
currentLat: null == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as num,currentLng: null == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [RerouteRequest].
extension RerouteRequestPatterns on RerouteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RerouteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RerouteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RerouteRequest value)  $default,){
final _that = this;
switch (_that) {
case _RerouteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RerouteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RerouteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_lat')  num currentLat, @JsonKey(name: 'current_lng')  num currentLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RerouteRequest() when $default != null:
return $default(_that.currentLat,_that.currentLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_lat')  num currentLat, @JsonKey(name: 'current_lng')  num currentLng)  $default,) {final _that = this;
switch (_that) {
case _RerouteRequest():
return $default(_that.currentLat,_that.currentLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_lat')  num currentLat, @JsonKey(name: 'current_lng')  num currentLng)?  $default,) {final _that = this;
switch (_that) {
case _RerouteRequest() when $default != null:
return $default(_that.currentLat,_that.currentLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RerouteRequest implements RerouteRequest {
  const _RerouteRequest({@JsonKey(name: 'current_lat') required this.currentLat, @JsonKey(name: 'current_lng') required this.currentLng});
  factory _RerouteRequest.fromJson(Map<String, dynamic> json) => _$RerouteRequestFromJson(json);

@override@JsonKey(name: 'current_lat') final  num currentLat;
@override@JsonKey(name: 'current_lng') final  num currentLng;

/// Create a copy of RerouteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RerouteRequestCopyWith<_RerouteRequest> get copyWith => __$RerouteRequestCopyWithImpl<_RerouteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RerouteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RerouteRequest&&(identical(other.currentLat, currentLat) || other.currentLat == currentLat)&&(identical(other.currentLng, currentLng) || other.currentLng == currentLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentLat,currentLng);

@override
String toString() {
  return 'RerouteRequest(currentLat: $currentLat, currentLng: $currentLng)';
}


}

/// @nodoc
abstract mixin class _$RerouteRequestCopyWith<$Res> implements $RerouteRequestCopyWith<$Res> {
  factory _$RerouteRequestCopyWith(_RerouteRequest value, $Res Function(_RerouteRequest) _then) = __$RerouteRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_lat') num currentLat,@JsonKey(name: 'current_lng') num currentLng
});




}
/// @nodoc
class __$RerouteRequestCopyWithImpl<$Res>
    implements _$RerouteRequestCopyWith<$Res> {
  __$RerouteRequestCopyWithImpl(this._self, this._then);

  final _RerouteRequest _self;
  final $Res Function(_RerouteRequest) _then;

/// Create a copy of RerouteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentLat = null,Object? currentLng = null,}) {
  return _then(_RerouteRequest(
currentLat: null == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as num,currentLng: null == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
