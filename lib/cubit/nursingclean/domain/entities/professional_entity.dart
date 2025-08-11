import 'package:equatable/equatable.dart';

class ProfessionalEntity extends Equatable {
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
  final dynamic user;
  final String createdAt;
  final String updatedAt;
  final bool isFavorite;
  final String role;
  final String providerType;

  const ProfessionalEntity({
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
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.role,
    required this.providerType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        experience,
        rating,
        about,
        workingInformation,
        daysHour,
        mapsLocation,
        certification,
        userId,
        user,
        createdAt,
        updatedAt,
        isFavorite,
        role,
        providerType,
      ];
}
