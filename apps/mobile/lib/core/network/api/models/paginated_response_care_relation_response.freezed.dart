// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response_care_relation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedResponseCareRelationResponse {

 List<CareRelationResponse> get data; PaginationMeta get meta;
/// Create a copy of PaginatedResponseCareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResponseCareRelationResponseCopyWith<PaginatedResponseCareRelationResponse> get copyWith => _$PaginatedResponseCareRelationResponseCopyWithImpl<PaginatedResponseCareRelationResponse>(this as PaginatedResponseCareRelationResponse, _$identity);

  /// Serializes this PaginatedResponseCareRelationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResponseCareRelationResponse&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'PaginatedResponseCareRelationResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginatedResponseCareRelationResponseCopyWith<$Res>  {
  factory $PaginatedResponseCareRelationResponseCopyWith(PaginatedResponseCareRelationResponse value, $Res Function(PaginatedResponseCareRelationResponse) _then) = _$PaginatedResponseCareRelationResponseCopyWithImpl;
@useResult
$Res call({
 List<CareRelationResponse> data, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginatedResponseCareRelationResponseCopyWithImpl<$Res>
    implements $PaginatedResponseCareRelationResponseCopyWith<$Res> {
  _$PaginatedResponseCareRelationResponseCopyWithImpl(this._self, this._then);

  final PaginatedResponseCareRelationResponse _self;
  final $Res Function(PaginatedResponseCareRelationResponse) _then;

/// Create a copy of PaginatedResponseCareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CareRelationResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}
/// Create a copy of PaginatedResponseCareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaginatedResponseCareRelationResponse].
extension PaginatedResponseCareRelationResponsePatterns on PaginatedResponseCareRelationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResponseCareRelationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResponseCareRelationResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResponseCareRelationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CareRelationResponse> data,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CareRelationResponse> data,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CareRelationResponse> data,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseCareRelationResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedResponseCareRelationResponse implements PaginatedResponseCareRelationResponse {
  const _PaginatedResponseCareRelationResponse({required final  List<CareRelationResponse> data, required this.meta}): _data = data;
  factory _PaginatedResponseCareRelationResponse.fromJson(Map<String, dynamic> json) => _$PaginatedResponseCareRelationResponseFromJson(json);

 final  List<CareRelationResponse> _data;
@override List<CareRelationResponse> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PaginationMeta meta;

/// Create a copy of PaginatedResponseCareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResponseCareRelationResponseCopyWith<_PaginatedResponseCareRelationResponse> get copyWith => __$PaginatedResponseCareRelationResponseCopyWithImpl<_PaginatedResponseCareRelationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedResponseCareRelationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResponseCareRelationResponse&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'PaginatedResponseCareRelationResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResponseCareRelationResponseCopyWith<$Res> implements $PaginatedResponseCareRelationResponseCopyWith<$Res> {
  factory _$PaginatedResponseCareRelationResponseCopyWith(_PaginatedResponseCareRelationResponse value, $Res Function(_PaginatedResponseCareRelationResponse) _then) = __$PaginatedResponseCareRelationResponseCopyWithImpl;
@override @useResult
$Res call({
 List<CareRelationResponse> data, PaginationMeta meta
});


@override $PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$PaginatedResponseCareRelationResponseCopyWithImpl<$Res>
    implements _$PaginatedResponseCareRelationResponseCopyWith<$Res> {
  __$PaginatedResponseCareRelationResponseCopyWithImpl(this._self, this._then);

  final _PaginatedResponseCareRelationResponse _self;
  final $Res Function(_PaginatedResponseCareRelationResponse) _then;

/// Create a copy of PaginatedResponseCareRelationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_PaginatedResponseCareRelationResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CareRelationResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginatedResponseCareRelationResponse
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
