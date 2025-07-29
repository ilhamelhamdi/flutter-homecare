// lib/features/nursing/domain/entities/nursing_case.dart
class NursingCase {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String mobilityStatus;
  final String careType;
  final String medicalRequirements;
  final String addOn;
  final double estimatedBudget;
  final List<String> images;
  final int relatedHealthRecordId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NursingCase({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.mobilityStatus,
    required this.careType,
    required this.medicalRequirements,
    this.addOn = '',
    this.estimatedBudget = 0,
    required this.images,
    required this.relatedHealthRecordId,
    required this.createdAt,
    required this.updatedAt,
  });
}

// lib/features/nursing/data/models/nursing_case_model.dart
class NursingCaseModel extends NursingCase {
  NursingCaseModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.mobilityStatus,
    required super.careType,
    required super.medicalRequirements,
    super.addOn,
    super.estimatedBudget,
    required super.images,
    required super.relatedHealthRecordId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NursingCaseModel.fromJson(Map<String, dynamic> json) {
    return NursingCaseModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mobilityStatus: json['mobility_status'] ?? '',
      careType: json['care_type'] ?? '',
      medicalRequirements: json['medical_requirements'] ?? '',
      addOn: json['add_on'] ?? '',
      estimatedBudget: (json['estimated_budget'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      relatedHealthRecordId: json['related_health_record_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'mobility_status': mobilityStatus,
      'care_type': careType,
      'medical_requirements': medicalRequirements,
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'images': images,
      'related_health_record_id': relatedHealthRecordId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
