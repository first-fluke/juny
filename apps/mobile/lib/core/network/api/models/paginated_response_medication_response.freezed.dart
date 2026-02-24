// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response_medication_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedResponseMedicationResponse {

 List<MedicationResponse> get data; PaginationMeta get meta;
/// Create a copy of PaginatedResponseMedicationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResponseMedicationResponseCopyWith<PaginatedResponseMedicationResponse> get copyWith => _$PaginatedResponseMedicationResponseCopyWithImpl<PaginatedResponseMedicationResponse>(this as PaginatedResponseMedicationResponse, _$identity);

  /// Serializes this PaginatedResponseMedicationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResponseMedicationResponse&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'PaginatedResponseMedicationResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginatedResponseMedicationResponseCopyWith<$Res>  {
  factory $PaginatedResponseMedicationResponseCopyWith(PaginatedResponseMedicationResponse value, $Res Function(PaginatedResponseMedicationResponse) _then) = _$PaginatedResponseMedicationResponseCopyWithImpl;
@useResult
$Res call({
 List<MedicationResponse> data, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginatedResponseMedicationResponseCopyWithImpl<$Res>
    implements $PaginatedResponseMedicationResponseCopyWith<$Res> {
  _$PaginatedResponseMedicationResponseCopyWithImpl(this._self, this._then);

  final PaginatedResponseMedicationResponse _self;
  final $Res Function(PaginatedResponseMedicationResponse) _then;

/// Create a copy of PaginatedResponseMedicationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}
/// Create a copy of PaginatedResponseMedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaginatedResponseMedicationResponse].
extension PaginatedResponseMedicationResponsePatterns on PaginatedResponseMedicationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResponseMedicationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResponseMedicationResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResponseMedicationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MedicationResponse> data,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MedicationResponse> data,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MedicationResponse> data,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseMedicationResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedResponseMedicationResponse implements PaginatedResponseMedicationResponse {
  const _PaginatedResponseMedicationResponse({required final  List<MedicationResponse> data, required this.meta}): _data = data;
  factory _PaginatedResponseMedicationResponse.fromJson(Map<String, dynamic> json) => _$PaginatedResponseMedicationResponseFromJson(json);

 final  List<MedicationResponse> _data;
@override List<MedicationResponse> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PaginationMeta meta;

/// Create a copy of PaginatedResponseMedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResponseMedicationResponseCopyWith<_PaginatedResponseMedicationResponse> get copyWith => __$PaginatedResponseMedicationResponseCopyWithImpl<_PaginatedResponseMedicationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedResponseMedicationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResponseMedicationResponse&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'PaginatedResponseMedicationResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResponseMedicationResponseCopyWith<$Res> implements $PaginatedResponseMedicationResponseCopyWith<$Res> {
  factory _$PaginatedResponseMedicationResponseCopyWith(_PaginatedResponseMedicationResponse value, $Res Function(_PaginatedResponseMedicationResponse) _then) = __$PaginatedResponseMedicationResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MedicationResponse> data, PaginationMeta meta
});


@override $PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$PaginatedResponseMedicationResponseCopyWithImpl<$Res>
    implements _$PaginatedResponseMedicationResponseCopyWith<$Res> {
  __$PaginatedResponseMedicationResponseCopyWithImpl(this._self, this._then);

  final _PaginatedResponseMedicationResponse _self;
  final $Res Function(_PaginatedResponseMedicationResponse) _then;

/// Create a copy of PaginatedResponseMedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_PaginatedResponseMedicationResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationResponse>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginatedResponseMedicationResponse
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
