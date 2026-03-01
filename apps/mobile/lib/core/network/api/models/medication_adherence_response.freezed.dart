// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_adherence_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationAdherenceResponse {

@JsonKey(name: 'host_id') String get hostId;@JsonKey(name: 'date_from') String get dateFrom;@JsonKey(name: 'date_to') String get dateTo; int get total; int get taken; int get missed;@JsonKey(name: 'adherence_rate') num get adherenceRate;
/// Create a copy of MedicationAdherenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationAdherenceResponseCopyWith<MedicationAdherenceResponse> get copyWith => _$MedicationAdherenceResponseCopyWithImpl<MedicationAdherenceResponse>(this as MedicationAdherenceResponse, _$identity);

  /// Serializes this MedicationAdherenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationAdherenceResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.total, total) || other.total == total)&&(identical(other.taken, taken) || other.taken == taken)&&(identical(other.missed, missed) || other.missed == missed)&&(identical(other.adherenceRate, adherenceRate) || other.adherenceRate == adherenceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,dateFrom,dateTo,total,taken,missed,adherenceRate);

@override
String toString() {
  return 'MedicationAdherenceResponse(hostId: $hostId, dateFrom: $dateFrom, dateTo: $dateTo, total: $total, taken: $taken, missed: $missed, adherenceRate: $adherenceRate)';
}


}

/// @nodoc
abstract mixin class $MedicationAdherenceResponseCopyWith<$Res>  {
  factory $MedicationAdherenceResponseCopyWith(MedicationAdherenceResponse value, $Res Function(MedicationAdherenceResponse) _then) = _$MedicationAdherenceResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo, int total, int taken, int missed,@JsonKey(name: 'adherence_rate') num adherenceRate
});




}
/// @nodoc
class _$MedicationAdherenceResponseCopyWithImpl<$Res>
    implements $MedicationAdherenceResponseCopyWith<$Res> {
  _$MedicationAdherenceResponseCopyWithImpl(this._self, this._then);

  final MedicationAdherenceResponse _self;
  final $Res Function(MedicationAdherenceResponse) _then;

/// Create a copy of MedicationAdherenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostId = null,Object? dateFrom = null,Object? dateTo = null,Object? total = null,Object? taken = null,Object? missed = null,Object? adherenceRate = null,}) {
  return _then(_self.copyWith(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,adherenceRate: null == adherenceRate ? _self.adherenceRate : adherenceRate // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationAdherenceResponse].
extension MedicationAdherenceResponsePatterns on MedicationAdherenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationAdherenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationAdherenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationAdherenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _MedicationAdherenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationAdherenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationAdherenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo,  int total,  int taken,  int missed, @JsonKey(name: 'adherence_rate')  num adherenceRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationAdherenceResponse() when $default != null:
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.total,_that.taken,_that.missed,_that.adherenceRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo,  int total,  int taken,  int missed, @JsonKey(name: 'adherence_rate')  num adherenceRate)  $default,) {final _that = this;
switch (_that) {
case _MedicationAdherenceResponse():
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.total,_that.taken,_that.missed,_that.adherenceRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host_id')  String hostId, @JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo,  int total,  int taken,  int missed, @JsonKey(name: 'adherence_rate')  num adherenceRate)?  $default,) {final _that = this;
switch (_that) {
case _MedicationAdherenceResponse() when $default != null:
return $default(_that.hostId,_that.dateFrom,_that.dateTo,_that.total,_that.taken,_that.missed,_that.adherenceRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationAdherenceResponse implements MedicationAdherenceResponse {
  const _MedicationAdherenceResponse({@JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'date_from') required this.dateFrom, @JsonKey(name: 'date_to') required this.dateTo, required this.total, required this.taken, required this.missed, @JsonKey(name: 'adherence_rate') required this.adherenceRate});
  factory _MedicationAdherenceResponse.fromJson(Map<String, dynamic> json) => _$MedicationAdherenceResponseFromJson(json);

@override@JsonKey(name: 'host_id') final  String hostId;
@override@JsonKey(name: 'date_from') final  String dateFrom;
@override@JsonKey(name: 'date_to') final  String dateTo;
@override final  int total;
@override final  int taken;
@override final  int missed;
@override@JsonKey(name: 'adherence_rate') final  num adherenceRate;

/// Create a copy of MedicationAdherenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationAdherenceResponseCopyWith<_MedicationAdherenceResponse> get copyWith => __$MedicationAdherenceResponseCopyWithImpl<_MedicationAdherenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationAdherenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationAdherenceResponse&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.total, total) || other.total == total)&&(identical(other.taken, taken) || other.taken == taken)&&(identical(other.missed, missed) || other.missed == missed)&&(identical(other.adherenceRate, adherenceRate) || other.adherenceRate == adherenceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostId,dateFrom,dateTo,total,taken,missed,adherenceRate);

@override
String toString() {
  return 'MedicationAdherenceResponse(hostId: $hostId, dateFrom: $dateFrom, dateTo: $dateTo, total: $total, taken: $taken, missed: $missed, adherenceRate: $adherenceRate)';
}


}

/// @nodoc
abstract mixin class _$MedicationAdherenceResponseCopyWith<$Res> implements $MedicationAdherenceResponseCopyWith<$Res> {
  factory _$MedicationAdherenceResponseCopyWith(_MedicationAdherenceResponse value, $Res Function(_MedicationAdherenceResponse) _then) = __$MedicationAdherenceResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host_id') String hostId,@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo, int total, int taken, int missed,@JsonKey(name: 'adherence_rate') num adherenceRate
});




}
/// @nodoc
class __$MedicationAdherenceResponseCopyWithImpl<$Res>
    implements _$MedicationAdherenceResponseCopyWith<$Res> {
  __$MedicationAdherenceResponseCopyWithImpl(this._self, this._then);

  final _MedicationAdherenceResponse _self;
  final $Res Function(_MedicationAdherenceResponse) _then;

/// Create a copy of MedicationAdherenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostId = null,Object? dateFrom = null,Object? dateTo = null,Object? total = null,Object? taken = null,Object? missed = null,Object? adherenceRate = null,}) {
  return _then(_MedicationAdherenceResponse(
hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,adherenceRate: null == adherenceRate ? _self.adherenceRate : adherenceRate // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
