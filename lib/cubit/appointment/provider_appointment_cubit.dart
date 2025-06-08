import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

  Future<void> fetchProviderAppointments(String providerType) async {
    try {
      emit(ProviderAppointmentLoading());

      final appointments =
          await _appointmentService.fetchProviderAppointments(providerType);
      emit(ProviderAppointmentLoaded(appointments));
    } catch (e) {
      print('Error in fetchProviderAppointments: $e');
      if (e.toString().contains('401')) {
        emit(ProviderAppointmentError(
            'Authentication failed. Please login again.'));
      } else if (e.toString().contains('403')) {
        emit(ProviderAppointmentError(
            'Access denied. Please check your permissions.'));
      } else {
        emit(ProviderAppointmentError('Error: ${e.toString()}'));
      }
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
      print('Rejecting appointment $appointmentId');

      await _appointmentService.rejectProviderAppointment(appointmentId);

      // Update the appointment in current state
      final currentState = state;
      if (currentState is ProviderAppointmentLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(status: 'rejected');
          }
          return appointment;
        }).toList();

        emit(ProviderAppointmentLoaded(updatedAppointments));
      }
    } catch (e) {
      print('Error rejecting appointment: $e');
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
