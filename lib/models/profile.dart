class Profile {
  final int id;
  final int userId;
  final int age;
  final int weight;
  final int height;
  final String phoneNumber;
  final String username;
  final String password;
  final String email;
  final String homeAddress;

  Profile({
    required this.id,
    required this.userId,
    required this.age,
    required this.weight,
    required this.height,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.email,
    required this.homeAddress,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      phoneNumber: json['phone_number'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      homeAddress: json['home_address'],
    );
  }
}
