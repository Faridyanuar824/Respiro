import 'package:go_router/go_router.dart';
import 'package:respiro/layouts/public_layout.dart';
import 'package:respiro/layouts/staff_layout.dart';
import 'package:respiro/features/auth/presentation/screens/login_screen.dart';
import 'package:respiro/features/auth/presentation/screens/register_screen.dart';
import 'package:respiro/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:respiro/features/patients/presentation/screens/patient_list_screen.dart';
import 'package:respiro/features/dashboard/presentation/screens/staff_dashboard_screen.dart';
import 'package:respiro/features/maps/presentation/screens/map_screen.dart';
import 'package:respiro/features/symptoms/presentation/screens/self_check_screen.dart';
import 'package:respiro/features/history/presentation/screens/history_screen.dart';
import 'package:respiro/features/facilities/presentation/screens/facilities_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return PublicLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              name: 'map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/self-check',
              name: 'selfCheck',
              builder: (context, state) => const SelfCheckScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/facilities',
              name: 'facilities',
              builder: (context, state) => const FacilitiesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return StaffLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/dashboard',
              name: 'staffDashboard',
              builder: (context, state) => const StaffDashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/patients',
              name: 'staffPatients',
              builder: (context, state) => const PatientListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/map',
              name: 'staffMap',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/analytics',
              name: 'staffAnalytics',
              builder: (context, state) => const StaffDashboardScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
