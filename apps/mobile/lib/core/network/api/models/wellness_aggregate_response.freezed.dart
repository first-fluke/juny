// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wellness_aggregate_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WellnessAggregateResponse {

@JsonKey(name: 'host_id') String get hostId; String get date;@JsonKey(name: 'total_logs') int get totalLogs;@JsonKey(name: 'by_status') Map<String, int> get byStatus;
/// Create a copy of WellnessAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessAggregateResponseCopyWith<WellnessAggregateResponse> get copyWith => _$WellnessAggregateResponseCopyWithImpl<WellnessAggregateResponse>(this as WellnessAggregateResponse, _$identity);

  /// Serializes this WellnessAggregateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessAggregateResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalLogs, totalLogs) || other.totalLogs == totalLogs)&&const DeepCollectionEquality().equals(other.byStatus, byStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,date,totalLogs,const DeepCollectionEquality().hash(byStatus));

@override
String toString() {
  return 'WellnessAggregateResponse(hostId: $hostId, date: $date, totalLogs: $totalLogs, byStatus: $byStatus)';
}


}

/// @nodoc
abstract mixin class $WellnessAggregateResponseCopyWith<$Res>  {
  factory $WellnessAggregateResponseCopyWith(WellnessAggregateResponse value, $Res Function(WellnessAggregateResponse) _then) = _$WellnessAggregateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, String date,@JsonKey(name: 'total_logs') int totalLogs,@JsonKey(name: 'by_status') Map<String, int> byStatus
});




}
/// @nodoc
class _$WellnessAggregateResponseCopyWithImpl<$Res>
    implements $WellnessAggregateResponseCopyWith<$Res> {
  _$WellnessAggregateResponseCopyWithImpl(this._self, this._then);

  final WellnessAggregateResponse _self;
  final $Res Function(WellnessAggregateResponse) _then;

/// Create a copy of WellnessAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? date = null,Object? totalLogs = null,Object? byStatus = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalLogs: null == totalLogs ? _self.totalLogs : totalLogs // ignore: cast_nullable_to_non_nullable
as int,byStatus: null == byStatus ? _self.byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessAggregateResponse].
extension WellnessAggregateResponsePatterns on WellnessAggregateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessAggregateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessAggregateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessAggregateResponse value)  $default,){
final _that = this;
switch (_that) {
case _WellnessAggregateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessAggregateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessAggregateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  String date, @JsonKey(name: 'total_logs')  int totalLogs, @JsonKey(name: 'by_status')  Map<String, int> byStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessAggregateResponse() when $default != null:
return $default(_that.hostId,_that.date,_that.totalLogs,_that.byStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId,  String date, @JsonKey(name: 'total_logs')  int totalLogs, @JsonKey(name: 'by_status')  Map<String, int> byStatus)  $default,) {final _that = this;
switch (_that) {
case _WellnessAggregateResponse():
return $default(_that.hostId,_that.date,_that.totalLogs,_that.byStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId,  String date, @JsonKey(name: 'total_logs')  int totalLogs, @JsonKey(name: 'by_status')  Map<String, int> byStatus)?  $default,) {final _that = this;
switch (_that) {
case _WellnessAggregateResponse() when $default != null:
return $default(_that.hostId,_that.date,_that.totalLogs,_that.byStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessAggregateResponse implements WellnessAggregateResponse {
  const _WellnessAggregateResponse({@JsonKey(name: 'host_id') required this.hostId, required this.date, @JsonKey(name: 'total_logs') required this.totalLogs, @JsonKey(name: 'by_status') required final  Map<String, int> byStatus}): _byStatus = byStatus;
  factory _WellnessAggregateResponse.fromJson(Map<String, dynamic> json) => _$WellnessAggregateResponseFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override final  String date;
@override@JsonKey(name: 'total_logs') final  int totalLogs;
 final  Map<String, int> _byStatus;
@override@JsonKey(name: 'by_status') Map<String, int> get byStatus {
  if (_byStatus is EqualUnmodifiableMapView) return _byStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byStatus);
}


/// Create a copy of WellnessAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessAggregateResponseCopyWith<_WellnessAggregateResponse> get copyWith => __$WellnessAggregateResponseCopyWithImpl<_WellnessAggregateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessAggregateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessAggregateResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalLogs, totalLogs) || other.totalLogs == totalLogs)&&const DeepCollectionEquality().equals(other._byStatus, _byStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,date,totalLogs,const DeepCollectionEquality().hash(_byStatus));

@override
String toString() {
  return 'WellnessAggregateResponse(hostId: $hostId, date: $date, totalLogs: $totalLogs, byStatus: $byStatus)';
}


}

/// @nodoc
abstract mixin class _$WellnessAggregateResponseCopyWith<$Res> implements $WellnessAggregateResponseCopyWith<$Res> {
  factory _$WellnessAggregateResponseCopyWith(_WellnessAggregateResponse value, $Res Function(_WellnessAggregateResponse) _then) = __$WellnessAggregateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId, String date,@JsonKey(name: 'total_logs') int totalLogs,@JsonKey(name: 'by_status') Map<String, int> byStatus
});




}
/// @nodoc
class __$WellnessAggregateResponseCopyWithImpl<$Res>
    implements _$WellnessAggregateResponseCopyWith<$Res> {
  __$WellnessAggregateResponseCopyWithImpl(this._self, this._then);

  final _WellnessAggregateResponse _self;
  final $Res Function(_WellnessAggregateResponse) _then;

/// Create a copy of WellnessAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? date = null,Object? totalLogs = null,Object? byStatus = null,}) {
  return _then(_WellnessAggregateResponse(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalLogs: null == totalLogs ? _self.totalLogs : totalLogs // ignore: cast_nullable_to_non_nullable
as int,byStatus: null == byStatus ? _self._byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
