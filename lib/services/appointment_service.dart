import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/models/appointment.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:m2health/utils.dart';

/// Service class for appointment-related operations
class AppointmentService {
  final Dio _dio;

  AppointmentService(this._dio);

  /// Fetch patient appointments
  Future<List<Appointment>> fetchPatientAppointments() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        Const.API_APPOINTMENT,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data['data'] == null) {
          return [];
        }

        final data = response.data['data'] as List;
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }

  /// Fetch provider appointments
  Future<List<ProviderAppointment>> fetchProviderAppointments(
      String providerType) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        '${Const.URL_API}/provider/appointments',
        queryParameters: {'provider_type': providerType},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data['data'] == null) {
          return [];
        }

        final data = response.data['data'] as List;
        return data.map((json) => ProviderAppointment.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load provider appointments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching provider appointments: $e');
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.put(
        '${Const.API_APPOINTMENT}/$appointmentId',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update appointment status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating appointment status: $e');
    }
  }

  /// Update provider appointment status
  Future<void> updateProviderAppointmentStatus(
      int appointmentId, String status) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.put(
        '${Const.URL_API}/provider/appointments/$appointmentId',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update provider appointment status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating provider appointment status: $e');
    }
  }

  /// Create a new appointment
  Future<void> createAppointment(Map<String, dynamic> appointmentData) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        Const.API_APPOINTMENT,
        data: appointmentData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create appointment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    }
  }

  /// Delete an appointment
  Future<void> deleteAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.delete(
        '${Const.API_APPOINTMENT}/$appointmentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete appointment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }
}
