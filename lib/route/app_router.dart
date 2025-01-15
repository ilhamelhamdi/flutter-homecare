import 'package:flutter/material.dart';
import 'package:m2health/views/splashscreen.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/locations/location_page.dart';
import 'package:m2health/cubit/partnership/request_page.dart';
import 'package:m2health/cubit/profiles/profile_page.dart';
import 'package:m2health/cubit/service_request/service_request_page.dart';
import 'package:m2health/cubit/signup/sign_up_page.dart';
import 'package:m2health/cubit/signin/sign_in_page.dart';
// import 'package:m2health/cubit/submenu/submenu_page.dart';
import 'package:m2health/cubit/partnership/list/partnership_list_page.dart';
import 'package:m2health/cubit/pharmacist_profile/pharmacist_profile_page.dart';
import 'package:m2health/cubit/pharmacist/pharmacist_page.dart';
// import 'package:m2health/cubit/nursing/nursing_page.dart';
import 'package:m2health/main.dart';
import 'package:m2health/views/dashboard.dart';
import 'package:m2health/views/pharmacist_services.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          SplashScreen(), // Set SplashScreen as the initial route
    ),
    GoRoute(
      path: AppRoutes.service_request,
      builder: (context, state) {
        final itemId = state.extra as int;
        return ServiceRequestPage(itemId: itemId);
      },
    ),
    GoRoute(
      path: '/locations',
      builder: (context, state) => LocationPage(),
    ),
    GoRoute(
      path: AppRoutes.partnership,
      builder: (context, state) {
        final itemId = state.extra as int;
        return RequestPage(itemId: itemId);
      },
    ),

    // GoRoute(
    //   path: AppRoutes.partnership,
    //   builder: (context, state) => RequestPage(),
    // ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => Dashboard(),
    ),
    // GoRoute(
    //   path: AppRoutes.submenu,
    //   builder: (context, state) => SubmenuPage(),
    // ),
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
      path: AppRoutes.partnership_list,
      builder: (context, state) {
        return PartnershipListPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        return ProfilePage();
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
        return PersonalPage();
      },
    ),
    // GoRoute(
    //   path: AppRoutes.nursing,
    //   builder: (context, state) {
    //     return NursingService();
    //   },
    // ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(child: HomePage());
  },
);
