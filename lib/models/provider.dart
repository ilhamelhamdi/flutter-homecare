class Provider {
  final int id;
  final String name;
  final String avatar;
  final int experience;
  final double rating;
  final String about;
  final String workingInformation;
  final String daysHour;
  final String mapsLocation;
  final String certification;
  final int userId;
  final String providerType; // 'pharmacist' or 'nurse'
  final User? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  Provider({
    required this.id,
    required this.name,
    required this.avatar,
    required this.experience,
    required this.rating,
    required this.about,
    required this.workingInformation,
    required this.daysHour,
    required this.mapsLocation,
    required this.certification,
    required this.userId,
    required this.providerType,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      experience: json['experience'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      about: json['about'] ?? '',
      workingInformation: json['working_information'] ?? '',
      daysHour: json['days_hour'] ?? '',
      mapsLocation: json['maps_location'] ?? '',
      certification: json['certification'] ?? '',
      userId: json['user_id'] ?? 0,
      providerType: json['provider_type'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'experience': experience,
      'rating': rating,
      'about': about,
      'working_information': workingInformation,
      'days_hour': daysHour,
      'maps_location': mapsLocation,
      'certification': certification,
      'user_id': userId,
      'provider_type': providerType,
      'user': user?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayName => name.isNotEmpty ? name : 'Unknown Provider';
  String get displayExperience => '${experience}Y++';
  String get displayRating => rating.toStringAsFixed(1);
  bool get isAvailable => true; // Can be expanded with real availability logic
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
