// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_relation_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareRelationUpdate {

@JsonKey(name: 'is_active') bool? get isActive; String? get role;
/// Create a copy of CareRelationUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareRelationUpdateCopyWith<CareRelationUpdate> get copyWith => _$CareRelationUpdateCopyWithImpl<CareRelationUpdate>(this as CareRelationUpdate, _$identity);

  /// Serializes this CareRelationUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareRelationUpdate&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isActive,role);

@override
String toString() {
  return 'CareRelationUpdate(isActive: $isActive, role: $role)';
}


}

/// @nodoc
abstract mixin class $CareRelationUpdateCopyWith<$Res>  {
  factory $CareRelationUpdateCopyWith(CareRelationUpdate value, $Res Function(CareRelationUpdate) _then) = _$CareRelationUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_active') bool? isActive, String? role
});




}
/// @nodoc
class _$CareRelationUpdateCopyWithImpl<$Res>
    implements $CareRelationUpdateCopyWith<$Res> {
  _$CareRelationUpdateCopyWithImpl(this._self, this._then);

  final CareRelationUpdate _self;
  final $Res Function(CareRelationUpdate) _then;

/// Create a copy of CareRelationUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isActive = freezed,Object? role = freezed,}) {
  return _then(_self.copyWith(
isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareRelationUpdate].
extension CareRelationUpdatePatterns on CareRelationUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareRelationUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareRelationUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareRelationUpdate value)  $default,){
final _that = this;
switch (_that) {
case _CareRelationUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareRelationUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _CareRelationUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_active')  bool? isActive,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareRelationUpdate() when $default != null:
return $default(_that.isActive,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_active')  bool? isActive,  String? role)  $default,) {final _that = this;
switch (_that) {
case _CareRelationUpdate():
return $default(_that.isActive,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_active')  bool? isActive,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _CareRelationUpdate() when $default != null:
return $default(_that.isActive,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareRelationUpdate implements CareRelationUpdate {
  const _CareRelationUpdate({@JsonKey(name: 'is_active') this.isActive, this.role});
  factory _CareRelationUpdate.fromJson(Map<String, dynamic> json) => _$CareRelationUpdateFromJson(json);

@override@JsonKey(name: 'is_active') final  bool? isActive;
@override final  String? role;

/// Create a copy of CareRelationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareRelationUpdateCopyWith<_CareRelationUpdate> get copyWith => __$CareRelationUpdateCopyWithImpl<_CareRelationUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareRelationUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareRelationUpdate&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isActive,role);

@override
String toString() {
  return 'CareRelationUpdate(isActive: $isActive, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CareRelationUpdateCopyWith<$Res> implements $CareRelationUpdateCopyWith<$Res> {
  factory _$CareRelationUpdateCopyWith(_CareRelationUpdate value, $Res Function(_CareRelationUpdate) _then) = __$CareRelationUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_active') bool? isActive, String? role
});




}
/// @nodoc
class __$CareRelationUpdateCopyWithImpl<$Res>
    implements _$CareRelationUpdateCopyWith<$Res> {
  __$CareRelationUpdateCopyWithImpl(this._self, this._then);

  final _CareRelationUpdate _self;
  final $Res Function(_CareRelationUpdate) _then;

/// Create a copy of CareRelationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isActive = freezed,Object? role = freezed,}) {
  return _then(_CareRelationUpdate(
isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
