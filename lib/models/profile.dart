class Profile {
  final int id;
  final int userId;
  final int age;
  final double weight;
  final double height;
  final String phoneNumber;
  final String username;
  final String email;
  final String homeAddress;
  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.age,
    required this.weight,
    required this.height,
    required this.phoneNumber,
    required this.username,
    required this.email,
    required this.homeAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      age: json['age'],
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      phoneNumber: json['phone_number'],
      username: json['username'],
      email: json['email'],
      homeAddress: json['home_address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'age': age,
      'weight': weight,
      'height': height,
      'phone_number': phoneNumber,
      'username': username,
      'email': email,
      'home_address': homeAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
