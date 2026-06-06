import 'package:go_router/go_router.dart';
import 'package:respiro/layouts/public_layout.dart';
import 'package:respiro/layouts/staff_layout.dart';
import 'package:respiro/features/auth/presentation/screens/login_screen.dart';
import 'package:respiro/features/auth/presentation/screens/register_screen.dart';
import 'package:respiro/features/auth/role_selection/screens/role_selection_screen.dart';
import 'package:respiro/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:respiro/features/maps/presentation/screens/map_screen.dart';
import 'package:respiro/features/symptoms/presentation/screens/self_check_screen.dart';
import 'package:respiro/features/facilities/presentation/screens/facilities_screen.dart';
import 'package:respiro/features/profile/presentation/screens/public_profile_screen.dart';
import 'package:respiro/features/staff/dashboard/staff_dashboard_screen.dart';
import 'package:respiro/features/staff/patients/patient_list_screen.dart';
import 'package:respiro/features/staff/patients/patient_detail_screen.dart';
import 'package:respiro/features/staff/patients/add_patient_screen.dart';
import 'package:respiro/features/staff/analytics/analytics_screen.dart';
import 'package:respiro/features/staff/profile/staff_profile_screen.dart';
import 'package:respiro/features/articles/presentation/screens/article_list_screen.dart';
import 'package:respiro/features/articles/presentation/screens/article_detail_screen.dart';
import 'package:respiro/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:respiro/features/profile/presentation/screens/settings_screen.dart';

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
    GoRoute(
      path: '/role-selection',
      name: 'roleSelection',
      builder: (context, state) => const RoleSelectionScreen(),
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
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const PublicProfileScreen(),
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
              path: '/staff/analytics',
              name: 'staffAnalytics',
              builder: (context, state) => const AnalyticsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/profile',
              name: 'staffProfile',
              builder: (context, state) => const StaffProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/staff/patients/detail',
      name: 'patientDetail',
      builder: (context, state) => const PatientDetailScreen(),
    ),
    GoRoute(
      path: '/staff/patients/add',
      name: 'addPatient',
      builder: (context, state) => const AddPatientScreen(),
    ),
    GoRoute(
      path: '/articles',
      name: 'articles',
      builder: (context, state) => const ArticleListScreen(),
    ),
    GoRoute(
      path: '/articles/detail',
      name: 'articleDetail',
      builder: (context, state) => const ArticleDetailScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      name: 'editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
