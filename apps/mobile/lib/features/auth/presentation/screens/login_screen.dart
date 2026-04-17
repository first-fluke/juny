import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forui/forui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template login_screen}
/// OAuth login screen with large, accessible buttons for senior users.
/// {@endtemplate}
class LoginScreen extends ConsumerStatefulWidget {
  /// {@macro login_screen}
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  bool _initialized = false;

  static const _scopes = ['email', 'profile'];

  @override
  void initState() {
    super.initState();
    unawaited(_initGoogleSignIn());
  }

  Future<void> _initGoogleSignIn() async {
    if (_initialized) return;

    final signIn = GoogleSignIn.instance;

    signIn.authenticationEvents
        .listen(_handleAuthEvent)
        .onError(_handleAuthError);

    await signIn.initialize(
      // clientId is auto-resolved from google-services.json / GoogleService-Info.plist
    );

    _initialized = true;
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) {
    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        unawaited(_onSignedIn(event.user));
      case GoogleSignInAuthenticationEventSignOut():
        setState(() => _isLoading = false);
    }
  }

  void _handleAuthError(Object error) {
    setState(() => _isLoading = false);
    if (mounted) {
      showFToast(
        context: context,
        title: Text('$error'),
      );
    }
  }

  Future<void> _onSignedIn(GoogleSignInAccount user) async {
    try {
      final authorization = await user.authorizationClient.authorizeScopes(
        _scopes,
      );
      final accessToken = authorization.accessToken;

      await _submitOAuthLogin(
        provider: OAuthLoginRequestProvider.google,
        oauthAccessToken: accessToken,
      );
    } on Exception catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          title: Text('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final signIn = GoogleSignIn.instance;
      if (signIn.supportsAuthenticate()) {
        await signIn.authenticate();
      }
    } on Exception catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showFToast(
          context: context,
          title: Text('$e'),
        );
      }
    }
  }

  Future<void> _submitOAuthLogin({
    required OAuthLoginRequestProvider provider,
    required String oauthAccessToken,
  }) async {
    await ref
        .read(authProvider.notifier)
        .login(
          provider: provider,
          oauthAccessToken: oauthAccessToken,
        );

    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState case AuthStateUnauthenticated()) {
      final l10n = AppLocalizations.of(context)!;
      showFToast(
        context: context,
        title: Text(l10n.errAuth002),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 96,
                color: context.theme.colors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 64),
              FButton(
                onPress: _isLoading ? null : _loginWithGoogle,
                prefix: _isLoading
                    ? const FCircularProgress()
                    : const FaIcon(FontAwesomeIcons.google, size: 24),
                child: Text(l10n.loginWithGoogle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
