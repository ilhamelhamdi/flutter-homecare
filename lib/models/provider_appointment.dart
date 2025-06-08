class ProviderAppointment {
  final int id;
  final int userId;
  final String type;
  final String status;
  final String date;
  final String hour;
  final String summary;
  final double payTotal;
  final String providerType;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> profileServiceData;
  final String createdAt;
  final String updatedAt;

  ProviderAppointment({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.date,
    required this.hour,
    required this.summary,
    required this.payTotal,
    required this.providerType,
    required this.patientData,
    required this.profileServiceData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderAppointment.fromJson(Map<String, dynamic> json) {
    return ProviderAppointment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      summary: json['summary'] ?? '',
      payTotal: (json['pay_total'] as num?)?.toDouble() ?? 0.0,
      providerType: json['provider_type'] ?? '',
      patientData: json['patient_data'] ?? {},
      profileServiceData: json['profile_services_data'] ?? {},
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  ProviderAppointment copyWith({
    String? status,
    // other fields as needed
  }) {
    return ProviderAppointment(
      id: this.id,
      userId: this.userId,
      type: this.type,
      status: status ?? this.status,
      date: this.date,
      hour: this.hour,
      summary: this.summary,
      payTotal: this.payTotal,
      providerType: this.providerType,
      patientData: this.patientData,
      profileServiceData: this.profileServiceData,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    );
  }
}
