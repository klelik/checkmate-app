import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/vehicle_check/presentation/screens/vehicle_input_screen.dart';
import '../../features/vehicle_check/presentation/screens/vehicle_confirm_screen.dart';
import '../../features/vehicle_check/presentation/screens/package_selection_screen.dart';
import '../../features/vehicle_check/presentation/screens/check_loading_screen.dart';
import '../../features/report/presentation/screens/report_screen.dart';
import '../../features/garage/presentation/screens/garage_screen.dart';
import '../../features/compare/presentation/screens/compare_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router({bool showOnboarding = true}) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: showOnboarding ? '/onboarding' : '/home',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
              GoRoute(
                path: '/check',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: VehicleInputScreen(),
                ),
              ),
              GoRoute(
                path: '/garage',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: GarageScreen(),
                ),
              ),
              GoRoute(
                path: '/compare',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CompareScreen(),
                ),
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/vehicle-confirm/:reg',
            builder: (context, state) => VehicleConfirmScreen(
              registrationNumber: state.pathParameters['reg'] ?? '',
            ),
          ),
          GoRoute(
            path: '/package-select/:reg',
            builder: (context, state) => PackageSelectionScreen(
              registrationNumber: state.pathParameters['reg'] ?? '',
            ),
          ),
          GoRoute(
            path: '/payment/:reg/:package',
            builder: (context, state) => PaymentScreen(
              registrationNumber: state.pathParameters['reg'] ?? '',
              packageType: state.pathParameters['package'] ?? 'full',
            ),
          ),
          GoRoute(
            path: '/check-loading/:reg',
            builder: (context, state) => CheckLoadingScreen(
              registrationNumber: state.pathParameters['reg'] ?? '',
            ),
          ),
          GoRoute(
            path: '/report/:reg',
            builder: (context, state) => ReportScreen(
              registrationNumber: state.pathParameters['reg'] ?? '',
            ),
          ),
        ],
      );
}
