// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wellness_log_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WellnessLogCreate {

@JsonKey(name: 'host_id') String get hostId; WellnessStatus get status; String get summary; dynamic get details;
/// Create a copy of WellnessLogCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessLogCreateCopyWith<WellnessLogCreate> get copyWith => _$WellnessLogCreateCopyWithImpl<WellnessLogCreate>(this as WellnessLogCreate, _$identity);

  /// Serializes this WellnessLogCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessLogCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,status,summary,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'WellnessLogCreate(hostId: $hostId, status: $status, summary: $summary, details: $details)';
}


}

/// @nodoc
abstract mixin class $WellnessLogCreateCopyWith<$Res>  {
  factory $WellnessLogCreateCopyWith(WellnessLogCreate value, $Res Function(WellnessLogCreate) _then) = _$WellnessLogCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, WellnessStatus status, String summary, dynamic details
});




}
/// @nodoc
class _$WellnessLogCreateCopyWithImpl<$Res>
    implements $WellnessLogCreateCopyWith<$Res> {
  _$WellnessLogCreateCopyWithImpl(this._self, this._then);

  final WellnessLogCreate _self;
  final $Res Function(WellnessLogCreate) _then;

/// Create a copy of WellnessLogCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? status = null,Object? summary = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WellnessStatus,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessLogCreate].
extension WellnessLogCreatePatterns on WellnessLogCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessLogCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessLogCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessLogCreate value)  $default,){
final _that = this;
switch (_that) {
case _WellnessLogCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessLogCreate value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessLogCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  WellnessStatus status,  String summary,  dynamic details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessLogCreate() when $default != null:
return $default(_that.hostId,_that.status,_that.summary,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  WellnessStatus status,  String summary,  dynamic details)  $default,) {final _that = this;
switch (_that) {
case _WellnessLogCreate():
return $default(_that.hostId,_that.status,_that.summary,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId,  WellnessStatus status,  String summary,  dynamic details)?  $default,) {final _that = this;
switch (_that) {
case _WellnessLogCreate() when $default != null:
return $default(_that.hostId,_that.status,_that.summary,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessLogCreate implements WellnessLogCreate {
  const _WellnessLogCreate({@JsonKey(name: 'host_id') required this.hostId, required this.status, required this.summary, this.details});
  factory _WellnessLogCreate.fromJson(Map<String, dynamic> json) => _$WellnessLogCreateFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override final  WellnessStatus status;
@override final  String summary;
@override final  dynamic details;

/// Create a copy of WellnessLogCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessLogCreateCopyWith<_WellnessLogCreate> get copyWith => __$WellnessLogCreateCopyWithImpl<_WellnessLogCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessLogCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessLogCreate&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,status,summary,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'WellnessLogCreate(hostId: $hostId, status: $status, summary: $summary, details: $details)';
}


}

/// @nodoc
abstract mixin class _$WellnessLogCreateCopyWith<$Res> implements $WellnessLogCreateCopyWith<$Res> {
  factory _$WellnessLogCreateCopyWith(_WellnessLogCreate value, $Res Function(_WellnessLogCreate) _then) = __$WellnessLogCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, WellnessStatus status, String summary, dynamic details
});




}
/// @nodoc
class __$WellnessLogCreateCopyWithImpl<$Res>
    implements _$WellnessLogCreateCopyWith<$Res> {
  __$WellnessLogCreateCopyWithImpl(this._self, this._then);

  final _WellnessLogCreate _self;
  final $Res Function(_WellnessLogCreate) _then;

/// Create a copy of WellnessLogCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? status = null,Object? summary = null,Object? details = freezed,}) {
  return _then(_WellnessLogCreate(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WellnessStatus,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
