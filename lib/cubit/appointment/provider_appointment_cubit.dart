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

  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      print('Updating appointment $appointmentId to status: $status');

      await _appointmentService.updateProviderAppointmentStatus(
          appointmentId, status);

      // Update the appointment in current state
      final currentState = state;
      if (currentState is ProviderAppointmentLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(status: status);
          }
          return appointment;
        }).toList();

        emit(ProviderAppointmentLoaded(updatedAppointments));
      }
    } catch (e) {
      print('Error updating appointment status: $e');
      emit(ProviderAppointmentError('Error updating status: ${e.toString()}'));
    }
  }

  Future<void> acceptAppointment(int appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'accepted');
  }

  Future<void> rejectAppointment(int appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'rejected');
  }

  Future<void> completeAppointment(int appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'completed');
  }
}
