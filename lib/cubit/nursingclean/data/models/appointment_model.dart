import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity{
  const AppointmentModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.status,
    required super.date,
    required super.hour,
    required super.summary,
    required super.payTotal,
    required super.profileServicesData,
    required super.createdAt,
    required super.updatedAt,
    required super.providerId,
    required super.providerType,
  });

  factory AppointmentModel.fromJSON(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id']?.toInt(),
      userId: map['user_id']?.toInt(),
      type: map['type'] ?? '',
      status: map['status'] ?? '',
      date: DateTime.parse(map['date']),
      hour: map['hour'] ?? '',
      summary: map['summary'] ?? '',
      payTotal: (map['pay_total'] is int)
          ? (map['pay_total'] as int).toDouble()
          : (map['pay_total'] is double)
              ? map['pay_total']
              : 0.0,
      profileServicesData: Map<String, dynamic>.from(map['profile_services_data'] ?? {}),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      providerId: map['provider_id']?.toInt(),
      providerType: map['provider_type'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'status': status,
      'date': date.toIso8601String(),
      'hour': hour,
      'summary': summary,
      'pay_total': payTotal,
      'profile_services_data': profileServicesData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'provider_id': providerId,
      'provider_type': providerType,
    };
  }
}