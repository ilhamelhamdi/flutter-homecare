import 'dart:convert';

import 'pharmacist_services.dart';

class Appointment {
  final int id;
  final String type;
  final String status;
  final String date;
  final String hour;
  final String summary;
  final double payTotal;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic> profileServiceData;

  Appointment({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.hour,
    required this.summary,
    required this.payTotal,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.profileServiceData,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      date: json['date'],
      hour: json['hour'],
      summary: json['summary'],
      payTotal: (json['pay_total'] as num).toDouble(),
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      profileServiceData: jsonDecode(json['profile_service_data']),
    );
  }
}
