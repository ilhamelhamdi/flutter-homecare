import 'package:equatable/equatable.dart';

class Issue {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String images; // Change to single string URL
  final String mobilityStatus;
  final String relatedHealthRecord;
  final String addOn;
  final double estimatedBudget;
  final DateTime createdAt;
  final DateTime updatedAt;

  Issue({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.images, // Change to single string URL
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] ?? '', // Change to single string URL
      mobilityStatus: json['mobility_status'] ?? '',
      relatedHealthRecord: json['related_health_record'] ?? '',
      addOn: json['add_on'] ?? '',
      estimatedBudget: (json['estimated_budget'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'images': images, // Change to single string URL
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord,
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object> get props => [];
}

class PersonalInitial extends PersonalState {}

class PersonalLoading extends PersonalState {}

class PersonalLoaded extends PersonalState {
  final List<Issue> issues;

  const PersonalLoaded(this.issues);

  @override
  List<Object> get props => [issues];
}

class PersonalError extends PersonalState {
  final String message;

  const PersonalError(this.message);

  @override
  List<Object> get props => [message];
}
