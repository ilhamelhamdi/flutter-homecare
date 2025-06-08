import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/provider_appointment_cubit.dart';
import 'package:m2health/cubit/appointment/appointment_page.dart';
import 'package:m2health/views/appointment/provider_appointment_page.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';

/// Manages appointment routing based on user role
class AppointmentManager {
  static const List<String> providerRoles = [
    'pharmacist',
    'nurse',
    'radiologist'
  ];

  /// Check if the current user is a provider
  static Future<bool> isProvider() async {
    final role = await Utils.getSpString(Const.ROLE);
    return role != null && providerRoles.contains(role.toLowerCase());
  }

  /// Get the provider type for the current user
  static Future<String?> getProviderType() async {
    final role = await Utils.getSpString(Const.ROLE);
    if (role != null && providerRoles.contains(role.toLowerCase())) {
      return role.toLowerCase();
    }
    return null;
  }

  /// Navigate to appropriate appointment page based on user role
  static Future<void> navigateToAppointmentPage(BuildContext context) async {
    final isUserProvider = await isProvider();

    if (isUserProvider) {
      final providerType = await getProviderType();
      if (providerType != null) {
        // Navigate to provider appointment page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ProviderAppointmentCubit(
                context.read(), // Dio instance
              ),
              child: ProviderAppointmentPage(providerType: providerType),
            ),
          ),
        );
      }
    } else {
      // Navigate to patient appointment page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AppointmentCubit(
              context.read(), // Dio instance
            ),
            child: AppointmentPage(),
          ),
        ),
      );
    }
  }

  /// Create appropriate appointment widget based on user role
  static Future<Widget> createAppointmentWidget() async {
    final isUserProvider = await isProvider();

    if (isUserProvider) {
      final providerType = await getProviderType();
      if (providerType != null) {
        return BlocProvider(
          create: (context) => ProviderAppointmentCubit(
            context.read(), // Dio instance
          ),
          child: ProviderAppointmentPage(providerType: providerType),
        );
      }
    }

    // Default to patient appointment page
    return BlocProvider(
      create: (context) => AppointmentCubit(
        context.read(), // Dio instance
      ),
      child: AppointmentPage(),
    );
  }
}
