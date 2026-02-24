import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/core/network/api/export.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  Future<void> _onSignedIn(GoogleSignInAccount user) async {
    try {
      final authorization = await user.authorizationClient.authorizeScopes(
        _scopes,
      );
      final accessToken = authorization.accessToken;

      await ref
          .read(authProvider.notifier)
          .login(
            provider: OAuthLoginRequestProvider.google,
            oauthAccessToken: accessToken,
          );
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 96,
                color: Color(0xFF0055FF),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 64),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loginWithGoogle,
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login, size: 28),
                label: Text(l10n.loginWithGoogle),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () {
                        // TODO(gracefullight): GitHub OAuth requires a
                        // web-based flow.
                      },
                icon: const Icon(Icons.code, size: 28),
                label: Text(l10n.loginWithGithub),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
