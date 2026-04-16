import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:mobile/features/concierge/presentation/screens/concierge_home_screen.dart';
import 'package:mobile/features/host/presentation/screens/host_home_screen.dart';
import 'package:mobile/features/live/presentation/screens/concierge_live_screen.dart';
import 'package:mobile/features/live/presentation/screens/host_live_screen.dart';
import 'package:mobile/features/medications/presentation/screens/medication_create_screen.dart';
import 'package:mobile/features/medications/presentation/screens/medications_screen.dart';
import 'package:mobile/features/navigation/presentation/screens/navigation_screen.dart';
import 'package:mobile/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:mobile/features/relations/presentation/screens/relation_create_screen.dart';
import 'package:mobile/features/relations/presentation/screens/relations_screen.dart';
import 'package:mobile/features/users/presentation/screens/profile_screen.dart';
import 'package:mobile/features/wellness/presentation/screens/wellness_create_screen.dart';
import 'package:mobile/features/wellness/presentation/screens/wellness_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
/// The main router with RBAC-based redirects.
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final path = state.uri.path;

      return switch (authState) {
        AuthStateLoading() => path == '/splash' ? null : '/splash',
        AuthStateUnauthenticated() => path == '/login' ? null : '/login',
        AuthStateAuthenticated(:final userRole) => () {
          if (path == '/splash' || path == '/login') {
            return switch (userRole) {
              'host' => '/home/host',
              'concierge' => '/home/concierge',
              _ => '/login',
            };
          }
          return null;
        }(),
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home/host',
        builder: (context, state) => const HostHomeScreen(),
      ),
      GoRoute(
        path: '/home/concierge',
        builder: (context, state) => const ConciergeHomeScreen(),
      ),
      GoRoute(
        path: '/live/host',
        builder: (context, state) => const HostLiveScreen(),
      ),
      GoRoute(
        path: '/live/concierge',
        builder: (context, state) => const ConciergeLiveScreen(),
      ),
      GoRoute(
        path: '/medications',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'] ?? '';
          return MedicationsScreen(hostId: hostId);
        },
      ),
      GoRoute(
        path: '/medications/create',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'] ?? '';
          return MedicationCreateScreen(hostId: hostId);
        },
      ),
      GoRoute(
        path: '/wellness',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'] ?? '';
          return WellnessScreen(hostId: hostId);
        },
      ),
      GoRoute(
        path: '/wellness/create',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'] ?? '';
          return WellnessCreateScreen(hostId: hostId);
        },
      ),
      GoRoute(
        path: '/relations',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'];
          final caregiverId = state.uri.queryParameters['caregiverId'];
          return RelationsScreen(hostId: hostId, caregiverId: caregiverId);
        },
      ),
      GoRoute(
        path: '/relations/create',
        builder: (context, state) => const RelationCreateScreen(),
      ),
      GoRoute(
        path: '/navigation',
        builder: (context, state) {
          final hostId = state.uri.queryParameters['hostId'] ?? '';
          return NavigationScreen(hostId: hostId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notifications/settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
    ],
  );
}
