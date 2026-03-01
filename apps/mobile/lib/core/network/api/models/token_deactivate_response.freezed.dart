// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_deactivate_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenDeactivateResponse {

@JsonKey(name: 'deactivated_count') int get deactivatedCount;
/// Create a copy of TokenDeactivateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenDeactivateResponseCopyWith<TokenDeactivateResponse> get copyWith => _$TokenDeactivateResponseCopyWithImpl<TokenDeactivateResponse>(this as TokenDeactivateResponse, _$identity);

  /// Serializes this TokenDeactivateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenDeactivateResponse&&(identical(other.deactivatedCount, deactivatedCount) || other.deactivatedCount == deactivatedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deactivatedCount);

@override
String toString() {
  return 'TokenDeactivateResponse(deactivatedCount: $deactivatedCount)';
}


}

/// @nodoc
abstract mixin class $TokenDeactivateResponseCopyWith<$Res>  {
  factory $TokenDeactivateResponseCopyWith(TokenDeactivateResponse value, $Res Function(TokenDeactivateResponse) _then) = _$TokenDeactivateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deactivated_count') int deactivatedCount
});




}
/// @nodoc
class _$TokenDeactivateResponseCopyWithImpl<$Res>
    implements $TokenDeactivateResponseCopyWith<$Res> {
  _$TokenDeactivateResponseCopyWithImpl(this._self, this._then);

  final TokenDeactivateResponse _self;
  final $Res Function(TokenDeactivateResponse) _then;

/// Create a copy of TokenDeactivateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deactivatedCount = null,}) {
  return _then(_self.copyWith(
deactivatedCount: null == deactivatedCount ? _self.deactivatedCount : deactivatedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenDeactivateResponse].
extension TokenDeactivateResponsePatterns on TokenDeactivateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenDeactivateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenDeactivateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenDeactivateResponse value)  $default,){
final _that = this;
switch (_that) {
case _TokenDeactivateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenDeactivateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TokenDeactivateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deactivated_count')  int deactivatedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenDeactivateResponse() when $default != null:
return $default(_that.deactivatedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deactivated_count')  int deactivatedCount)  $default,) {final _that = this;
switch (_that) {
case _TokenDeactivateResponse():
return $default(_that.deactivatedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deactivated_count')  int deactivatedCount)?  $default,) {final _that = this;
switch (_that) {
case _TokenDeactivateResponse() when $default != null:
return $default(_that.deactivatedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenDeactivateResponse implements TokenDeactivateResponse {
  const _TokenDeactivateResponse({@JsonKey(name: 'deactivated_count') required this.deactivatedCount});
  factory _TokenDeactivateResponse.fromJson(Map<String, dynamic> json) => _$TokenDeactivateResponseFromJson(json);

@override@JsonKey(name: 'deactivated_count') final  int deactivatedCount;

/// Create a copy of TokenDeactivateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenDeactivateResponseCopyWith<_TokenDeactivateResponse> get copyWith => __$TokenDeactivateResponseCopyWithImpl<_TokenDeactivateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenDeactivateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenDeactivateResponse&&(identical(other.deactivatedCount, deactivatedCount) || other.deactivatedCount == deactivatedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deactivatedCount);

@override
String toString() {
  return 'TokenDeactivateResponse(deactivatedCount: $deactivatedCount)';
}


}

/// @nodoc
abstract mixin class _$TokenDeactivateResponseCopyWith<$Res> implements $TokenDeactivateResponseCopyWith<$Res> {
  factory _$TokenDeactivateResponseCopyWith(_TokenDeactivateResponse value, $Res Function(_TokenDeactivateResponse) _then) = __$TokenDeactivateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deactivated_count') int deactivatedCount
});




}
/// @nodoc
class __$TokenDeactivateResponseCopyWithImpl<$Res>
    implements _$TokenDeactivateResponseCopyWith<$Res> {
  __$TokenDeactivateResponseCopyWithImpl(this._self, this._then);

  final _TokenDeactivateResponse _self;
  final $Res Function(_TokenDeactivateResponse) _then;

/// Create a copy of TokenDeactivateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deactivatedCount = null,}) {
  return _then(_TokenDeactivateResponse(
deactivatedCount: null == deactivatedCount ? _self.deactivatedCount : deactivatedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
