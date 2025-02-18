class PersonalCase {
  final int id;
  final String title;
  final String description;
  final String images; // Change to single string URL
  final String mobilityStatus;
  final String relatedHealthRecord;
  final String addOn;
  final double estimatedBudget;
  final int userId;

  PersonalCase({
    required this.id,
    required this.title,
    required this.description,
    required this.images, // Change to single string URL
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.userId,
  });

  factory PersonalCase.fromJson(Map<String, dynamic> json) {
    return PersonalCase(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] ?? '', // Change to single string URL
      mobilityStatus: json['mobility_status'] ?? '',
      relatedHealthRecord: json['related_health_record'] ?? '',
      addOn: json['add_on'] ?? '',
      estimatedBudget: (json['estimated_budget'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images, // Change to single string URL
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord,
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'user_id': userId,
    };
  }
}
