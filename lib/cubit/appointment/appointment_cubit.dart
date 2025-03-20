import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:m2health/models/appointment.dart';
import 'package:m2health/const.dart';
import 'package:dio/dio.dart';
import 'package:m2health/utils.dart'; // Import utils to get token

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final Dio _dio;

  AppointmentCubit(this._dio) : super(AppointmentInitial());

  Future<void> fetchAppointments() async {
    try {
      emit(AppointmentLoading());
      final token = await Utils.getSpString(
          Const.TOKEN); // Get token from shared preferences
      final response = await _dio.get(
        Const.API_APPOINTMENT,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final appointments = (response.data['data'] as List)
            .map((json) => Appointment.fromJson(json))
            .toList();

        print('data yang muncul : $appointments');

        emit(AppointmentLoaded(appointments));
      } else {
        emit(AppointmentError('Failed to load appointments'));
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.delete(
        '${Const.API_APPOINTMENT}/$appointmentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        fetchAppointments(); // Refresh the list of appointments
      } else {
        throw Exception('Failed to delete appointment');
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.put(
        '${Const.API_APPOINTMENT}/$appointmentId', // Assuming this endpoint updates the appointment
        data: {'status': 'Cancelled'}, // Update the status to "Cancelled"
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (state is AppointmentLoaded) {
          final currentState = state as AppointmentLoaded;
          final updatedAppointments =
              currentState.appointments.map((appointment) {
            if (appointment.id == appointmentId) {
              return appointment.copyWith(status: 'Cancelled'); // Update status
            }
            return appointment;
          }).toList();

          emit(AppointmentLoaded(updatedAppointments));
        }
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
