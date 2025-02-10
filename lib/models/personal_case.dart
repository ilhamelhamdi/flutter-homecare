class PersonalCase {
  final int id;
  final String title;
  final String description;
  final String images;
  final String mobilityStatus;
  final String relatedHealthRecord;
  final String addOn;
  final double estimatedBudget;
  final int userId;

  PersonalCase({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.userId,
  });

  factory PersonalCase.fromJson(Map<String, dynamic> json) {
    return PersonalCase(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: json['images'],
      mobilityStatus: json['mobility_status'],
      relatedHealthRecord: json['related_health_record'],
      addOn: json['add_on'],
      estimatedBudget: json['estimated_budget'],
      userId: json['user_id'],
    );
  }
}
