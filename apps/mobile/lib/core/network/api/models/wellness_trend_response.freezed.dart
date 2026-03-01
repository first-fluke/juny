// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wellness_trend_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WellnessTrendResponse {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'date_from') String get dateFrom;@JsonKey(name: 'date_to') String get dateTo;@JsonKey(name: 'daily_stats') List<DailyWellnessStat> get dailyStats;
/// Create a copy of WellnessTrendResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessTrendResponseCopyWith<WellnessTrendResponse> get copyWith => _$WellnessTrendResponseCopyWithImpl<WellnessTrendResponse>(this as WellnessTrendResponse, _$identity);

  /// Serializes this WellnessTrendResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessTrendResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&const DeepCollectionEquality().equals(other.dailyStats, dailyStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,dateFrom,dateTo,const DeepCollectionEquality().hash(dailyStats));

@override
String toString() {
  return 'WellnessTrendResponse(hostId: $hostId, dateFrom: $dateFrom, dateTo: $dateTo, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class $WellnessTrendResponseCopyWith<$Res>  {
  factory $WellnessTrendResponseCopyWith(WellnessTrendResponse value, $Res Function(WellnessTrendResponse) _then) = _$WellnessTrendResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo,@JsonKey(name: 'daily_stats') List<DailyWellnessStat> dailyStats
});




}
/// @nodoc
class _$WellnessTrendResponseCopyWithImpl<$Res>
    implements $WellnessTrendResponseCopyWith<$Res> {
  _$WellnessTrendResponseCopyWithImpl(this._self, this._then);

  final WellnessTrendResponse _self;
  final $Res Function(WellnessTrendResponse) _then;

/// Create a copy of WellnessTrendResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? dateFrom = null,Object? dateTo = null,Object? dailyStats = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,dailyStats: null == dailyStats ? _self.dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<DailyWellnessStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessTrendResponse].
extension WellnessTrendResponsePatterns on WellnessTrendResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessTrendResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessTrendResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessTrendResponse value)  $default,){
final _that = this;
switch (_that) {
case _WellnessTrendResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessTrendResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessTrendResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'daily_stats')  List<DailyWellnessStat> dailyStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessTrendResponse() when $default != null:
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.dailyStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'daily_stats')  List<DailyWellnessStat> dailyStats)  $default,) {final _that = this;
switch (_that) {
case _WellnessTrendResponse():
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.dailyStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'daily_stats')  List<DailyWellnessStat> dailyStats)?  $default,) {final _that = this;
switch (_that) {
case _WellnessTrendResponse() when $default != null:
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.dailyStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessTrendResponse implements WellnessTrendResponse {
  const _WellnessTrendResponse({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'date_from') required this.dateFrom, @JsonKey(name: 'date_to') required this.dateTo, @JsonKey(name: 'daily_stats') required final  List<DailyWellnessStat> dailyStats}): _dailyStats = dailyStats;
  factory _WellnessTrendResponse.fromJson(Map<String, dynamic> json) => _$WellnessTrendResponseFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'date_from') final  String dateFrom;
@override@JsonKey(name: 'date_to') final  String dateTo;
 final  List<DailyWellnessStat> _dailyStats;
@override@JsonKey(name: 'daily_stats') List<DailyWellnessStat> get dailyStats {
  if (_dailyStats is EqualUnmodifiableListView) return _dailyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyStats);
}


/// Create a copy of WellnessTrendResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessTrendResponseCopyWith<_WellnessTrendResponse> get copyWith => __$WellnessTrendResponseCopyWithImpl<_WellnessTrendResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessTrendResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessTrendResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&const DeepCollectionEquality().equals(other._dailyStats, _dailyStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,dateFrom,dateTo,const DeepCollectionEquality().hash(_dailyStats));

@override
String toString() {
  return 'WellnessTrendResponse(hostId: $hostId, dateFrom: $dateFrom, dateTo: $dateTo, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class _$WellnessTrendResponseCopyWith<$Res> implements $WellnessTrendResponseCopyWith<$Res> {
  factory _$WellnessTrendResponseCopyWith(_WellnessTrendResponse value, $Res Function(_WellnessTrendResponse) _then) = __$WellnessTrendResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo,@JsonKey(name: 'daily_stats') List<DailyWellnessStat> dailyStats
});




}
/// @nodoc
class __$WellnessTrendResponseCopyWithImpl<$Res>
    implements _$WellnessTrendResponseCopyWith<$Res> {
  __$WellnessTrendResponseCopyWithImpl(this._self, this._then);

  final _WellnessTrendResponse _self;
  final $Res Function(_WellnessTrendResponse) _then;

/// Create a copy of WellnessTrendResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? dateFrom = null,Object? dateTo = null,Object? dailyStats = null,}) {
  return _then(_WellnessTrendResponse(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,dailyStats: null == dailyStats ? _self._dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<DailyWellnessStat>,
  ));
}


}

// dart format on
