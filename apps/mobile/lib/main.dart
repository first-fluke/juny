import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:mobile/core/router/router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/theme/generated_theme.dart';
import 'package:mobile/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// Top-level background message handler required by [FirebaseMessaging].
///
/// Must be a top-level (non-anonymous) function so it can be registered
/// with the FCM plugin's background isolate. Heavy processing should be
/// deferred to the foreground; only lightweight work should happen here.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be initialised in the background isolate as well.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  var crashlyticsEnabled = false;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // firebase_core 4.x may crash on iOS simulator when default app
      // is already configured by native runtime.
      final shouldInitFirebase =
          !(defaultTargetPlatform == TargetPlatform.iOS && kDebugMode);

      if (shouldInitFirebase && Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        crashlyticsEnabled = true;
      }

      // Register the top-level background handler before runApp so the plugin
      // can set it up in the headless background isolate.
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      FlutterError.onError = (errorDetails) {
        if (crashlyticsEnabled) {
          unawaited(
            FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails),
          );
        }
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        if (crashlyticsEnabled) {
          unawaited(
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
          );
        }
        return true;
      };

      if (crashlyticsEnabled && kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          false,
        );
      }

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      if (crashlyticsEnabled) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
        );
      }
    },
  );
}

/// {@template my_app}
/// The root widget of the application.
/// {@endtemplate}
class MyApp extends ConsumerStatefulWidget {
  /// {@macro my_app}
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Warm up the push notification provider so it begins listening to
    // auth state changes immediately after the widget tree is mounted.
    ref.read(pushNotificationProvider);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final fTheme = isDark ? generatedDarkTheme : generatedLightTheme;

    return FTheme(
      data: fTheme,
      child: MaterialApp.router(
        title: 'Juny',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        builder: (context, child) =>
            FToaster(child: child ?? const SizedBox.shrink()),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          ...FLocalizations.localizationsDelegates,
        ],
        supportedLocales: const [Locale('ko'), Locale('en'), Locale('ja')],
      ),
    );
  }
}
