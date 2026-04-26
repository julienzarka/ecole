import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ape/presentation/ape_request_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/reports/presentation/declare_flow_screen.dart';
import '../features/reports/presentation/home_screen.dart';
import '../features/schools/presentation/school_search_screen.dart';
import '../features/stats/presentation/stats_screen.dart';

/// Routes nommées (cf. specs/parcours.md, identifiants E.xx).
abstract class AppRoutes {
  static const String onboarding = '/onboarding'; // E.01
  static const String login = '/login'; // E.02
  static const String role = '/role'; // E.03
  static const String schoolSearch = '/school-search'; // E.04
  static const String apeRequest = '/ape-request'; // E.07-E.08
  static const String home = '/'; // E.10 / E.11
  static const String declare = '/declare'; // E.20-E.28
  static const String profile = '/profile'; // E.70
  static const String stats = '/stats'; // E.60-E.62
}

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.role,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.schoolSearch,
        builder: (context, state) => const SchoolSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.apeRequest,
        builder: (context, state) => const ApeRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.declare,
        builder: (context, state) => const DeclareFlowScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
    ],
  );
});
