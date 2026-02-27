// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedResponseUserResponse {

 List<UserResponse> get data; PaginationMeta get meta;
/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResponseUserResponseCopyWith<PaginatedResponseUserResponse> get copyWith => _$PaginatedResponseUserResponseCopyWithImpl<PaginatedResponseUserResponse>(this as PaginatedResponseUserResponse, _$identity);

  /// Serializes this PaginatedResponseUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResponseUserResponse&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'PaginatedResponseUserResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginatedResponseUserResponseCopyWith<$Res>  {
  factory $PaginatedResponseUserResponseCopyWith(PaginatedResponseUserResponse value, $Res Function(PaginatedResponseUserResponse) _then) = _$PaginatedResponseUserResponseCopyWithImpl;
@useResult
$Res call({
 List<UserResponse> data, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginatedResponseUserResponseCopyWithImpl<$Res>
    implements $PaginatedResponseUserResponseCopyWith<$Res> {
  _$PaginatedResponseUserResponseCopyWithImpl(this._self, this._then);

  final PaginatedResponseUserResponse _self;
  final $Res Function(PaginatedResponseUserResponse) _then;

/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<UserResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}
/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaginatedResponseUserResponse].
extension PaginatedResponseUserResponsePatterns on PaginatedResponseUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResponseUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResponseUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResponseUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserResponse> data,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserResponse> data,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse():
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserResponse> data,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseUserResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedResponseUserResponse implements PaginatedResponseUserResponse {
  const _PaginatedResponseUserResponse({required final  List<UserResponse> data, required this.meta}): _data = data;
  factory _PaginatedResponseUserResponse.fromJson(Map<String, dynamic> json) => _$PaginatedResponseUserResponseFromJson(json);

 final  List<UserResponse> _data;
@override List<UserResponse> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PaginationMeta meta;

/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResponseUserResponseCopyWith<_PaginatedResponseUserResponse> get copyWith => __$PaginatedResponseUserResponseCopyWithImpl<_PaginatedResponseUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedResponseUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResponseUserResponse&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'PaginatedResponseUserResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResponseUserResponseCopyWith<$Res> implements $PaginatedResponseUserResponseCopyWith<$Res> {
  factory _$PaginatedResponseUserResponseCopyWith(_PaginatedResponseUserResponse value, $Res Function(_PaginatedResponseUserResponse) _then) = __$PaginatedResponseUserResponseCopyWithImpl;
@override @useResult
$Res call({
 List<UserResponse> data, PaginationMeta meta
});


@override $PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$PaginatedResponseUserResponseCopyWithImpl<$Res>
    implements _$PaginatedResponseUserResponseCopyWith<$Res> {
  __$PaginatedResponseUserResponseCopyWithImpl(this._self, this._then);

  final _PaginatedResponseUserResponse _self;
  final $Res Function(_PaginatedResponseUserResponse) _then;

/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_PaginatedResponseUserResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<UserResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginatedResponseUserResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
