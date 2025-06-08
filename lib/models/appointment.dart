import 'dart:convert';

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
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      summary: json['summary'] ?? '',
      payTotal: (json['pay_total'] as num?)?.toDouble() ?? 0.0,
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      // Fix: Handle null profile_services_data properly
      profileServiceData: json['profile_services_data'] != null
          ? (json['profile_services_data'] is String
              ? jsonDecode(json['profile_services_data'])
              : json['profile_services_data'])
          : <String, dynamic>{}, // Return empty map instead of null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'date': date,
      'hour': hour,
      'summary': summary,
      'pay_total': payTotal,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_services_data': jsonEncode(profileServiceData),
    };
  }

  Appointment copyWith({
    int? id,
    String? type,
    String? status,
    String? date,
    String? hour,
    String? summary,
    double? payTotal,
    int? userId,
    String? createdAt,
    String? updatedAt,
    Map<String, dynamic>? profileServiceData,
  }) {
    return Appointment(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      summary: summary ?? this.summary,
      payTotal: payTotal ?? this.payTotal,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileServiceData: profileServiceData ?? this.profileServiceData,
    );
  }
}
