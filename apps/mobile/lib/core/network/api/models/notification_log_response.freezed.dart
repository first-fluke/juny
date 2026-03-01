// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_log_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationLogResponse {

 String get id;@JsonKey(name: 'recipient_id') String get recipientId; String get title; String get body; String get status; String get channel; dynamic get metadata;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of NotificationLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationLogResponseCopyWith<NotificationLogResponse> get copyWith => _$NotificationLogResponseCopyWithImpl<NotificationLogResponse>(this as NotificationLogResponse, _$identity);

  /// Serializes this NotificationLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.status, status) || other.status == status)&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipientId,title,body,status,channel,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'NotificationLogResponse(id: $id, recipientId: $recipientId, title: $title, body: $body, status: $status, channel: $channel, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationLogResponseCopyWith<$Res>  {
  factory $NotificationLogResponseCopyWith(NotificationLogResponse value, $Res Function(NotificationLogResponse) _then) = _$NotificationLogResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'recipient_id') String recipientId, String title, String body, String status, String channel, dynamic metadata,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$NotificationLogResponseCopyWithImpl<$Res>
    implements $NotificationLogResponseCopyWith<$Res> {
  _$NotificationLogResponseCopyWithImpl(this._self, this._then);

  final NotificationLogResponse _self;
  final $Res Function(NotificationLogResponse) _then;

/// Create a copy of NotificationLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipientId = null,Object? title = null,Object? body = null,Object? status = null,Object? channel = null,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationLogResponse].
extension NotificationLogResponsePatterns on NotificationLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'recipient_id')  String recipientId,  String title,  String body,  String status,  String channel,  dynamic metadata, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationLogResponse() when $default != null:
return $default(_that.id,_that.recipientId,_that.title,_that.body,_that.status,_that.channel,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'recipient_id')  String recipientId,  String title,  String body,  String status,  String channel,  dynamic metadata, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationLogResponse():
return $default(_that.id,_that.recipientId,_that.title,_that.body,_that.status,_that.channel,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'recipient_id')  String recipientId,  String title,  String body,  String status,  String channel,  dynamic metadata, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationLogResponse() when $default != null:
return $default(_that.id,_that.recipientId,_that.title,_that.body,_that.status,_that.channel,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationLogResponse implements NotificationLogResponse {
  const _NotificationLogResponse({required this.id, @JsonKey(name: 'recipient_id') required this.recipientId, required this.title, required this.body, required this.status, required this.channel, required this.metadata, @JsonKey(name: 'created_at') required this.createdAt});
  factory _NotificationLogResponse.fromJson(Map<String, dynamic> json) => _$NotificationLogResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'recipient_id') final  String recipientId;
@override final  String title;
@override final  String body;
@override final  String status;
@override final  String channel;
@override final  dynamic metadata;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of NotificationLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationLogResponseCopyWith<_NotificationLogResponse> get copyWith => __$NotificationLogResponseCopyWithImpl<_NotificationLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.status, status) || other.status == status)&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipientId,title,body,status,channel,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'NotificationLogResponse(id: $id, recipientId: $recipientId, title: $title, body: $body, status: $status, channel: $channel, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationLogResponseCopyWith<$Res> implements $NotificationLogResponseCopyWith<$Res> {
  factory _$NotificationLogResponseCopyWith(_NotificationLogResponse value, $Res Function(_NotificationLogResponse) _then) = __$NotificationLogResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'recipient_id') String recipientId, String title, String body, String status, String channel, dynamic metadata,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$NotificationLogResponseCopyWithImpl<$Res>
    implements _$NotificationLogResponseCopyWith<$Res> {
  __$NotificationLogResponseCopyWithImpl(this._self, this._then);

  final _NotificationLogResponse _self;
  final $Res Function(_NotificationLogResponse) _then;

/// Create a copy of NotificationLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipientId = null,Object? title = null,Object? body = null,Object? status = null,Object? channel = null,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_NotificationLogResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
