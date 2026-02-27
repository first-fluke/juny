// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cleanup_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CleanupResponse {

@JsonKey(name: 'deleted_wellness_logs') int get deletedWellnessLogs;@JsonKey(name: 'deactivated_tokens') int get deactivatedTokens;
/// Create a copy of CleanupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CleanupResponseCopyWith<CleanupResponse> get copyWith => _$CleanupResponseCopyWithImpl<CleanupResponse>(this as CleanupResponse, _$identity);

  /// Serializes this CleanupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanupResponse&&(identical(other.deletedWellnessLogs, deletedWellnessLogs) || other.deletedWellnessLogs == deletedWellnessLogs)&&(identical(other.deactivatedTokens, deactivatedTokens) || other.deactivatedTokens == deactivatedTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deletedWellnessLogs,deactivatedTokens);

@override
String toString() {
  return 'CleanupResponse(deletedWellnessLogs: $deletedWellnessLogs, deactivatedTokens: $deactivatedTokens)';
}


}

/// @nodoc
abstract mixin class $CleanupResponseCopyWith<$Res>  {
  factory $CleanupResponseCopyWith(CleanupResponse value, $Res Function(CleanupResponse) _then) = _$CleanupResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deleted_wellness_logs') int deletedWellnessLogs,@JsonKey(name: 'deactivated_tokens') int deactivatedTokens
});




}
/// @nodoc
class _$CleanupResponseCopyWithImpl<$Res>
    implements $CleanupResponseCopyWith<$Res> {
  _$CleanupResponseCopyWithImpl(this._self, this._then);

  final CleanupResponse _self;
  final $Res Function(CleanupResponse) _then;

/// Create a copy of CleanupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deletedWellnessLogs = null,Object? deactivatedTokens = null,}) {
  return _then(_self.copyWith(
deletedWellnessLogs: null == deletedWellnessLogs ? _self.deletedWellnessLogs : deletedWellnessLogs // ignore: cast_nullable_to_non_nullable
as int,deactivatedTokens: null == deactivatedTokens ? _self.deactivatedTokens : deactivatedTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CleanupResponse].
extension CleanupResponsePatterns on CleanupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CleanupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CleanupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CleanupResponse value)  $default,){
final _that = this;
switch (_that) {
case _CleanupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CleanupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CleanupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deleted_wellness_logs')  int deletedWellnessLogs, @JsonKey(name: 'deactivated_tokens')  int deactivatedTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CleanupResponse() when $default != null:
return $default(_that.deletedWellnessLogs,_that.deactivatedTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deleted_wellness_logs')  int deletedWellnessLogs, @JsonKey(name: 'deactivated_tokens')  int deactivatedTokens)  $default,) {final _that = this;
switch (_that) {
case _CleanupResponse():
return $default(_that.deletedWellnessLogs,_that.deactivatedTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deleted_wellness_logs')  int deletedWellnessLogs, @JsonKey(name: 'deactivated_tokens')  int deactivatedTokens)?  $default,) {final _that = this;
switch (_that) {
case _CleanupResponse() when $default != null:
return $default(_that.deletedWellnessLogs,_that.deactivatedTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CleanupResponse implements CleanupResponse {
  const _CleanupResponse({@JsonKey(name: 'deleted_wellness_logs') required this.deletedWellnessLogs, @JsonKey(name: 'deactivated_tokens') required this.deactivatedTokens});
  factory _CleanupResponse.fromJson(Map<String, dynamic> json) => _$CleanupResponseFromJson(json);

@override@JsonKey(name: 'deleted_wellness_logs') final  int deletedWellnessLogs;
@override@JsonKey(name: 'deactivated_tokens') final  int deactivatedTokens;

/// Create a copy of CleanupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CleanupResponseCopyWith<_CleanupResponse> get copyWith => __$CleanupResponseCopyWithImpl<_CleanupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CleanupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CleanupResponse&&(identical(other.deletedWellnessLogs, deletedWellnessLogs) || other.deletedWellnessLogs == deletedWellnessLogs)&&(identical(other.deactivatedTokens, deactivatedTokens) || other.deactivatedTokens == deactivatedTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deletedWellnessLogs,deactivatedTokens);

@override
String toString() {
  return 'CleanupResponse(deletedWellnessLogs: $deletedWellnessLogs, deactivatedTokens: $deactivatedTokens)';
}


}

/// @nodoc
abstract mixin class _$CleanupResponseCopyWith<$Res> implements $CleanupResponseCopyWith<$Res> {
  factory _$CleanupResponseCopyWith(_CleanupResponse value, $Res Function(_CleanupResponse) _then) = __$CleanupResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deleted_wellness_logs') int deletedWellnessLogs,@JsonKey(name: 'deactivated_tokens') int deactivatedTokens
});




}
/// @nodoc
class __$CleanupResponseCopyWithImpl<$Res>
    implements _$CleanupResponseCopyWith<$Res> {
  __$CleanupResponseCopyWithImpl(this._self, this._then);

  final _CleanupResponse _self;
  final $Res Function(_CleanupResponse) _then;

/// Create a copy of CleanupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deletedWellnessLogs = null,Object? deactivatedTokens = null,}) {
  return _then(_CleanupResponse(
deletedWellnessLogs: null == deletedWellnessLogs ? _self.deletedWellnessLogs : deletedWellnessLogs // ignore: cast_nullable_to_non_nullable
as int,deactivatedTokens: null == deactivatedTokens ? _self.deactivatedTokens : deactivatedTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
