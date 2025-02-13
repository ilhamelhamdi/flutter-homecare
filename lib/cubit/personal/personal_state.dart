import 'package:equatable/equatable.dart';

class Issue {
  final int id;
  final int userId;
  final String title;
  final String description;
  final List<String> images;
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
    required this.images,
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      images: (json['images'] as String).split(','),
      mobilityStatus: json['mobility_status'],
      relatedHealthRecord: json['related_health_record'],
      addOn: json['add_on'],
      estimatedBudget: json['estimated_budget'].toDouble(),
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
      'images': images.join(','),
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
