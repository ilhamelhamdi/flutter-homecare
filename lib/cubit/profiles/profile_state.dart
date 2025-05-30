import 'package:meta/meta.dart';
import 'package:m2health/models/profile.dart';

@immutable
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUnauthenticated extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final Profile profile;

  ProfileUpdateSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
