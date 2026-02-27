// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileUploadResponse {

 String get key; String get url;@JsonKey(name: 'content_type') String get contentType; int get size;
/// Create a copy of FileUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileUploadResponseCopyWith<FileUploadResponse> get copyWith => _$FileUploadResponseCopyWithImpl<FileUploadResponse>(this as FileUploadResponse, _$identity);

  /// Serializes this FileUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileUploadResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,url,contentType,size);

@override
String toString() {
  return 'FileUploadResponse(key: $key, url: $url, contentType: $contentType, size: $size)';
}


}

/// @nodoc
abstract mixin class $FileUploadResponseCopyWith<$Res>  {
  factory $FileUploadResponseCopyWith(FileUploadResponse value, $Res Function(FileUploadResponse) _then) = _$FileUploadResponseCopyWithImpl;
@useResult
$Res call({
 String key, String url,@JsonKey(name: 'content_type') String contentType, int size
});




}
/// @nodoc
class _$FileUploadResponseCopyWithImpl<$Res>
    implements $FileUploadResponseCopyWith<$Res> {
  _$FileUploadResponseCopyWithImpl(this._self, this._then);

  final FileUploadResponse _self;
  final $Res Function(FileUploadResponse) _then;

/// Create a copy of FileUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? url = null,Object? contentType = null,Object? size = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FileUploadResponse].
extension FileUploadResponsePatterns on FileUploadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileUploadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileUploadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileUploadResponse value)  $default,){
final _that = this;
switch (_that) {
case _FileUploadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileUploadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FileUploadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String url, @JsonKey(name: 'content_type')  String contentType,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileUploadResponse() when $default != null:
return $default(_that.key,_that.url,_that.contentType,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String url, @JsonKey(name: 'content_type')  String contentType,  int size)  $default,) {final _that = this;
switch (_that) {
case _FileUploadResponse():
return $default(_that.key,_that.url,_that.contentType,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String url, @JsonKey(name: 'content_type')  String contentType,  int size)?  $default,) {final _that = this;
switch (_that) {
case _FileUploadResponse() when $default != null:
return $default(_that.key,_that.url,_that.contentType,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileUploadResponse implements FileUploadResponse {
  const _FileUploadResponse({required this.key, required this.url, @JsonKey(name: 'content_type') required this.contentType, required this.size});
  factory _FileUploadResponse.fromJson(Map<String, dynamic> json) => _$FileUploadResponseFromJson(json);

@override final  String key;
@override final  String url;
@override@JsonKey(name: 'content_type') final  String contentType;
@override final  int size;

/// Create a copy of FileUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileUploadResponseCopyWith<_FileUploadResponse> get copyWith => __$FileUploadResponseCopyWithImpl<_FileUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileUploadResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,url,contentType,size);

@override
String toString() {
  return 'FileUploadResponse(key: $key, url: $url, contentType: $contentType, size: $size)';
}


}

/// @nodoc
abstract mixin class _$FileUploadResponseCopyWith<$Res> implements $FileUploadResponseCopyWith<$Res> {
  factory _$FileUploadResponseCopyWith(_FileUploadResponse value, $Res Function(_FileUploadResponse) _then) = __$FileUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String url,@JsonKey(name: 'content_type') String contentType, int size
});




}
/// @nodoc
class __$FileUploadResponseCopyWithImpl<$Res>
    implements _$FileUploadResponseCopyWith<$Res> {
  __$FileUploadResponseCopyWithImpl(this._self, this._then);

  final _FileUploadResponse _self;
  final $Res Function(_FileUploadResponse) _then;

/// Create a copy of FileUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? url = null,Object? contentType = null,Object? size = null,}) {
  return _then(_FileUploadResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
