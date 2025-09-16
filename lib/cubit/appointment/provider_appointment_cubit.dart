import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:meta/meta.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:m2health/services/appointment_service.dart';

part 'provider_appointment_state.dart';

class ProviderAppointmentCubit extends Cubit<ProviderAppointmentState> {
  final Dio _dio;
  late final AppointmentService _appointmentService;

  ProviderAppointmentCubit(this._dio) : super(ProviderAppointmentInitial()) {
    _appointmentService = AppointmentService(_dio);
  }

  Future<void> fetchProviderAppointments(String? providerType) async {
    try {
      emit(ProviderAppointmentLoading());

      final token = await Utils.getSpString(Const.TOKEN);
      var queryParam = <String, dynamic>{};
      if (providerType != null) {
        queryParam['provider_type'] = providerType;
      }
      final response = await Dio().get(
        Const.API_PROVIDER_APPOINTMENTS,
        queryParameters: queryParam,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('=== API Response Debug ===');
      print('Status: ${response.statusCode}');
      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> appointmentsJson = response.data['data'] ?? [];

        // Parse appointments and enrich with patient data if needed
        final List<ProviderAppointment> appointments = [];

        for (var appointmentJson in appointmentsJson) {
          var appointment = ProviderAppointment.fromJson(appointmentJson);

          // If patient data is empty, fetch it separately
          if (appointment.patientData.isEmpty && appointment.userId > 0) {
            print('Fetching patient data for user_id: ${appointment.userId}');
            final patientData = await _fetchPatientData(appointment.userId);

            // Create new appointment with patient data
            appointment = ProviderAppointment(
              id: appointment.id,
              userId: appointment.userId,
              type: appointment.type,
              status: appointment.status,
              date: appointment.date,
              hour: appointment.hour,
              summary: appointment.summary,
              payTotal: appointment.payTotal,
              providerType: appointment.providerType,
              patientData: patientData,
              profileServiceData: appointment.profileServiceData,
              createdAt: appointment.createdAt,
              updatedAt: appointment.updatedAt,
            );
          }

          appointments.add(appointment);
        }

        emit(ProviderAppointmentLoaded(appointments));
      } else {
        emit(ProviderAppointmentError('Failed to load appointments'));
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      emit(ProviderAppointmentError('Error: $e'));
    }
  }

  Future<Map<String, dynamic>> _fetchPatientData(int userId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await Dio().get(
        '${Const.API_PROFILE}?user_id=$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Patient data response: ${response.data}');

      if (response.statusCode == 200 && response.data['data'] != null) {
        return Map<String, dynamic>.from(response.data['data']);
      }

      return {};
    } catch (e) {
      print('Error fetching patient data: $e');
      return {};
    }
  }

  Future<void> acceptAppointment(int appointmentId) async {
    try {
      print('Accepting appointment $appointmentId');

      await _appointmentService.acceptProviderAppointment(appointmentId);

      // Update the appointment in current state
      final currentState = state;
      if (currentState is ProviderAppointmentLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(status: 'accepted');
          }
          return appointment;
        }).toList();

        emit(ProviderAppointmentLoaded(updatedAppointments));
      }
    } catch (e) {
      print('Error accepting appointment: $e');
      emit(ProviderAppointmentError(
          'Error accepting appointment: ${e.toString()}'));
    }
  }

  Future<void> rejectAppointment(int appointmentId) async {
    try {
      print('=== CUBIT: REJECTING APPOINTMENT ===');
      print('Appointment ID: $appointmentId');

      // Get current state before making the API call
      final currentState = state;
      print('Current state type: ${currentState.runtimeType}');

      if (currentState is ProviderAppointmentLoaded) {
        print(
            'Number of appointments in current state: ${currentState.appointments.length}');
        final targetAppointment = currentState.appointments
            .where((appointment) => appointment.id == appointmentId)
            .firstOrNull;

        if (targetAppointment != null) {
          print('Target appointment found:');
          print('  - ID: ${targetAppointment.id}');
          print('  - Current Status: ${targetAppointment.status}');
          print(
              '  - Patient: ${targetAppointment.patientData['username'] ?? targetAppointment.patientData['name'] ?? 'Unknown'}');
          print('  - Date: ${targetAppointment.date}');
          print('  - Time: ${targetAppointment.hour}');
        } else {
          print('❌ Target appointment not found in current state');
          emit(ProviderAppointmentError(
              'Appointment not found in current state'));
          return;
        }
      }

      print('Calling appointment service to reject appointment...');
      await _appointmentService.rejectProviderAppointment(appointmentId);
      print('✅ Appointment service call completed successfully');

      // Update the appointment in current state
      if (currentState is ProviderAppointmentLoaded) {
        print('Updating appointment status in cubit state...');
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            print(
                'Updating appointment ${appointment.id} status from ${appointment.status} to rejected');
            return appointment.copyWith(status: 'rejected');
          }
          return appointment;
        }).toList();

        print(
            'Emitting updated state with ${updatedAppointments.length} appointments');
        emit(ProviderAppointmentLoaded(updatedAppointments));
        print('✅ State updated successfully');
      } else {
        print(
            '⚠️ Current state is not ProviderAppointmentLoaded, cannot update');
      }
    } catch (e) {
      print('=== CUBIT: REJECT APPOINTMENT ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('❌ Emitting error state');
      emit(ProviderAppointmentError(
          'Error rejecting appointment: ${e.toString()}'));
    }
  }

  Future<void> completeAppointment(int appointmentId) async {
    try {
      print('Completing appointment $appointmentId');

      await _appointmentService.completeProviderAppointment(appointmentId);

      // Update the appointment in current state
      final currentState = state;
      if (currentState is ProviderAppointmentLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(status: 'completed');
          }
          return appointment;
        }).toList();

        emit(ProviderAppointmentLoaded(updatedAppointments));
      }
    } catch (e) {
      print('Error completing appointment: $e');
      emit(ProviderAppointmentError(
          'Error completing appointment: ${e.toString()}'));
    }
  }

  // Remove the old updateAppointmentStatus method since we now have specific methods
}
