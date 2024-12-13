import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_homecare/cubit/locations/location_page.dart';
import 'package:flutter_homecare/cubit/partnership/request_page.dart';
import 'package:flutter_homecare/cubit/profiles/profile_page.dart';
import 'package:flutter_homecare/cubit/service_request/service_request_page.dart';
import 'package:flutter_homecare/cubit/signup/sign_up_page.dart';
import 'package:flutter_homecare/cubit/signin/sign_in_page.dart';
import 'package:flutter_homecare/cubit/submenu/submenu_page.dart';
import 'package:flutter_homecare/cubit/partnership/list/partnership_list_page.dart';
import 'package:flutter_homecare/main.dart';
import 'package:flutter_homecare/views/dashboard.dart';
import 'package:flutter_homecare/views/tenders.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  routes: [
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
    GoRoute(
      path: AppRoutes.submenu,
      builder: (context, state) => SubmenuPage(),
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
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(child: HomePage());
  },
);
