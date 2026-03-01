// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_deactivate_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenDeactivateRequest {

 List<String> get tokens;
/// Create a copy of TokenDeactivateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenDeactivateRequestCopyWith<TokenDeactivateRequest> get copyWith => _$TokenDeactivateRequestCopyWithImpl<TokenDeactivateRequest>(this as TokenDeactivateRequest, _$identity);

  /// Serializes this TokenDeactivateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenDeactivateRequest&&const DeepCollectionEquality().equals(other.tokens, tokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tokens));

@override
String toString() {
  return 'TokenDeactivateRequest(tokens: $tokens)';
}


}

/// @nodoc
abstract mixin class $TokenDeactivateRequestCopyWith<$Res>  {
  factory $TokenDeactivateRequestCopyWith(TokenDeactivateRequest value, $Res Function(TokenDeactivateRequest) _then) = _$TokenDeactivateRequestCopyWithImpl;
@useResult
$Res call({
 List<String> tokens
});




}
/// @nodoc
class _$TokenDeactivateRequestCopyWithImpl<$Res>
    implements $TokenDeactivateRequestCopyWith<$Res> {
  _$TokenDeactivateRequestCopyWithImpl(this._self, this._then);

  final TokenDeactivateRequest _self;
  final $Res Function(TokenDeactivateRequest) _then;

/// Create a copy of TokenDeactivateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokens = null,}) {
  return _then(_self.copyWith(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenDeactivateRequest].
extension TokenDeactivateRequestPatterns on TokenDeactivateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenDeactivateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenDeactivateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenDeactivateRequest value)  $default,){
final _that = this;
switch (_that) {
case _TokenDeactivateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenDeactivateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TokenDeactivateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> tokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenDeactivateRequest() when $default != null:
return $default(_that.tokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> tokens)  $default,) {final _that = this;
switch (_that) {
case _TokenDeactivateRequest():
return $default(_that.tokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> tokens)?  $default,) {final _that = this;
switch (_that) {
case _TokenDeactivateRequest() when $default != null:
return $default(_that.tokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenDeactivateRequest implements TokenDeactivateRequest {
  const _TokenDeactivateRequest({required final  List<String> tokens}): _tokens = tokens;
  factory _TokenDeactivateRequest.fromJson(Map<String, dynamic> json) => _$TokenDeactivateRequestFromJson(json);

 final  List<String> _tokens;
@override List<String> get tokens {
  if (_tokens is EqualUnmodifiableListView) return _tokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tokens);
}


/// Create a copy of TokenDeactivateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenDeactivateRequestCopyWith<_TokenDeactivateRequest> get copyWith => __$TokenDeactivateRequestCopyWithImpl<_TokenDeactivateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenDeactivateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenDeactivateRequest&&const DeepCollectionEquality().equals(other._tokens, _tokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tokens));

@override
String toString() {
  return 'TokenDeactivateRequest(tokens: $tokens)';
}


}

/// @nodoc
abstract mixin class _$TokenDeactivateRequestCopyWith<$Res> implements $TokenDeactivateRequestCopyWith<$Res> {
  factory _$TokenDeactivateRequestCopyWith(_TokenDeactivateRequest value, $Res Function(_TokenDeactivateRequest) _then) = __$TokenDeactivateRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> tokens
});




}
/// @nodoc
class __$TokenDeactivateRequestCopyWithImpl<$Res>
    implements _$TokenDeactivateRequestCopyWith<$Res> {
  __$TokenDeactivateRequestCopyWithImpl(this._self, this._then);

  final _TokenDeactivateRequest _self;
  final $Res Function(_TokenDeactivateRequest) _then;

/// Create a copy of TokenDeactivateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokens = null,}) {
  return _then(_TokenDeactivateRequest(
tokens: null == tokens ? _self._tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
