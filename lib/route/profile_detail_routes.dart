import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/cubit/profiles/profile_details/edit_profile.dart';
import 'package:m2health/cubit/profiles/profile_details/medical_record/medical_record.dart';
import 'package:m2health/route/app_routes.dart';

class ProfileDetailRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.medicalRecord,
      builder: (context, state) {
        return MedicalRecordsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.pharmagenomics,
      builder: (context, state) {
        return PharmagenomicsProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) {
        final args = state.extra as EditProfilePageArgs;
        return BlocProvider.value(
          value: args.profileCubit,
          child: EditProfilePage(profile: args.profile),
        );
      }
    ),
  ];
}