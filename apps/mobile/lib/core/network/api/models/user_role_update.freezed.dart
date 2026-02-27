// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRoleUpdate {

 String get role;
/// Create a copy of UserRoleUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRoleUpdateCopyWith<UserRoleUpdate> get copyWith => _$UserRoleUpdateCopyWithImpl<UserRoleUpdate>(this as UserRoleUpdate, _$identity);

  /// Serializes this UserRoleUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRoleUpdate&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UserRoleUpdate(role: $role)';
}


}

/// @nodoc
abstract mixin class $UserRoleUpdateCopyWith<$Res>  {
  factory $UserRoleUpdateCopyWith(UserRoleUpdate value, $Res Function(UserRoleUpdate) _then) = _$UserRoleUpdateCopyWithImpl;
@useResult
$Res call({
 String role
});




}
/// @nodoc
class _$UserRoleUpdateCopyWithImpl<$Res>
    implements $UserRoleUpdateCopyWith<$Res> {
  _$UserRoleUpdateCopyWithImpl(this._self, this._then);

  final UserRoleUpdate _self;
  final $Res Function(UserRoleUpdate) _then;

/// Create a copy of UserRoleUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRoleUpdate].
extension UserRoleUpdatePatterns on UserRoleUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRoleUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRoleUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRoleUpdate value)  $default,){
final _that = this;
switch (_that) {
case _UserRoleUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRoleUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _UserRoleUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRoleUpdate() when $default != null:
return $default(_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role)  $default,) {final _that = this;
switch (_that) {
case _UserRoleUpdate():
return $default(_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role)?  $default,) {final _that = this;
switch (_that) {
case _UserRoleUpdate() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRoleUpdate implements UserRoleUpdate {
  const _UserRoleUpdate({required this.role});
  factory _UserRoleUpdate.fromJson(Map<String, dynamic> json) => _$UserRoleUpdateFromJson(json);

@override final  String role;

/// Create a copy of UserRoleUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRoleUpdateCopyWith<_UserRoleUpdate> get copyWith => __$UserRoleUpdateCopyWithImpl<_UserRoleUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRoleUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRoleUpdate&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UserRoleUpdate(role: $role)';
}


}

/// @nodoc
abstract mixin class _$UserRoleUpdateCopyWith<$Res> implements $UserRoleUpdateCopyWith<$Res> {
  factory _$UserRoleUpdateCopyWith(_UserRoleUpdate value, $Res Function(_UserRoleUpdate) _then) = __$UserRoleUpdateCopyWithImpl;
@override @useResult
$Res call({
 String role
});




}
/// @nodoc
class __$UserRoleUpdateCopyWithImpl<$Res>
    implements _$UserRoleUpdateCopyWith<$Res> {
  __$UserRoleUpdateCopyWithImpl(this._self, this._then);

  final _UserRoleUpdate _self;
  final $Res Function(_UserRoleUpdate) _then;

/// Create a copy of UserRoleUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_UserRoleUpdate(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
