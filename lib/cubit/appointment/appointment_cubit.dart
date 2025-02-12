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
        emit(AppointmentLoaded(appointments));
      } else {
        emit(AppointmentError('Failed to load appointments'));
      }
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
