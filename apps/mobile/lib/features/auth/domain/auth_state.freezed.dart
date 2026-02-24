// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStateUnauthenticated value)?  unauthenticated,TResult Function( AuthStateLoading value)?  loading,TResult Function( AuthStateAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthStateLoading() when loading != null:
return loading(_that);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStateUnauthenticated value)  unauthenticated,required TResult Function( AuthStateLoading value)  loading,required TResult Function( AuthStateAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case AuthStateUnauthenticated():
return unauthenticated(_that);case AuthStateLoading():
return loading(_that);case AuthStateAuthenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStateUnauthenticated value)?  unauthenticated,TResult? Function( AuthStateLoading value)?  loading,TResult? Function( AuthStateAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthStateLoading() when loading != null:
return loading(_that);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unauthenticated,TResult Function()?  loading,TResult Function( String accessToken,  String refreshToken,  String userRole)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthStateLoading() when loading != null:
return loading();case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that.accessToken,_that.refreshToken,_that.userRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unauthenticated,required TResult Function()  loading,required TResult Function( String accessToken,  String refreshToken,  String userRole)  authenticated,}) {final _that = this;
switch (_that) {
case AuthStateUnauthenticated():
return unauthenticated();case AuthStateLoading():
return loading();case AuthStateAuthenticated():
return authenticated(_that.accessToken,_that.refreshToken,_that.userRole);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unauthenticated,TResult? Function()?  loading,TResult? Function( String accessToken,  String refreshToken,  String userRole)?  authenticated,}) {final _that = this;
switch (_that) {
case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthStateLoading() when loading != null:
return loading();case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that.accessToken,_that.refreshToken,_that.userRole);case _:
  return null;

}
}

}

/// @nodoc


class AuthStateUnauthenticated implements AuthState {
  const AuthStateUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class AuthStateLoading implements AuthState {
  const AuthStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class AuthStateAuthenticated implements AuthState {
  const AuthStateAuthenticated({required this.accessToken, required this.refreshToken, required this.userRole});
  

 final  String accessToken;
 final  String refreshToken;
 final  String userRole;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateAuthenticatedCopyWith<AuthStateAuthenticated> get copyWith => _$AuthStateAuthenticatedCopyWithImpl<AuthStateAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateAuthenticated&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.userRole, userRole) || other.userRole == userRole));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,userRole);

@override
String toString() {
  return 'AuthState.authenticated(accessToken: $accessToken, refreshToken: $refreshToken, userRole: $userRole)';
}


}

/// @nodoc
abstract mixin class $AuthStateAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthStateAuthenticatedCopyWith(AuthStateAuthenticated value, $Res Function(AuthStateAuthenticated) _then) = _$AuthStateAuthenticatedCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String userRole
});




}
/// @nodoc
class _$AuthStateAuthenticatedCopyWithImpl<$Res>
    implements $AuthStateAuthenticatedCopyWith<$Res> {
  _$AuthStateAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthStateAuthenticated _self;
  final $Res Function(AuthStateAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? userRole = null,}) {
  return _then(AuthStateAuthenticated(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
