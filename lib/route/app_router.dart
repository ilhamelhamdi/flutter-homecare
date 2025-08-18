import 'package:flutter/material.dart';
import 'package:m2health/cubit/appointment/appointment_module.dart';
import 'package:m2health/cubit/nursing/pages/nursing_services_page.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/pharmacist_services.dart';
import 'package:m2health/views/appointment/unified_appointment_page.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/locations/location_page.dart';
import 'package:m2health/cubit/profiles/profile_page.dart';
import 'package:m2health/cubit/signup/sign_up_page.dart';
import 'package:m2health/cubit/signin/sign_in_page.dart';
import 'package:m2health/cubit/pharmacist_profile/pharmacist_profile_page.dart';
import 'package:m2health/cubit/personal/personal_page.dart';
import 'package:m2health/main.dart';
import 'package:m2health/views/dashboard.dart';
import 'package:m2health/views/diabetic_care.dart';
import 'package:m2health/views/favourites.dart';
import 'package:m2health/views/medical_store.dart';
import 'package:path/path.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: _rootNavigatorKey,
  routes: [
    // For routes with NavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => Dashboard(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.appointment,
              builder: (context, state) => AppointmentPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.medicalStore,
              builder: (context, state) => MedicalStorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favourite,
              builder: (context, state) => FavouritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/locations',
      builder: (context, state) => LocationPage(),
    ),

    GoRoute(
      path: AppRoutes.appointment,
      builder: (context, state) => UnifiedAppointmentPage(),
    ),

    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => SignUpPage(),
    ),

    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        return SignInPage();
      },
    ),

    GoRoute(
      path: AppRoutes.pharmaServices,
      builder: (context, state) {
        return PharmaServices();
      },
    ),
    GoRoute(
      path: AppRoutes.nursingServices,
      builder: (context, state) {
        return NursingService();
      },
    ),
    GoRoute(
      path: AppRoutes.diabeticCare,
      builder: (context, state) {
        return DiabeticCare();
      },
    ),

    GoRoute(
      path: AppRoutes.pharma_profile,
      builder: (context, state) {
        return PharmacistProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.personal,
      builder: (context, state) {
        return PersonalPage(
          title: 'Personal Page',
          serviceType: 'Default Service',
        );
      },
    ),
  ],
  // errorPageBuilder: (context, state) {
  //   return MaterialPage(child: HomePage());
  // },
);
