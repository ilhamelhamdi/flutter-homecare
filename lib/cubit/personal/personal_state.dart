import 'package:equatable/equatable.dart';

abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object> get props => [];
}

class PersonalInitial extends PersonalState {}

class PersonalLoading extends PersonalState {}

class PersonalLoaded extends PersonalState {
  final String mobilityStatus;

  const PersonalLoaded(this.mobilityStatus);

  @override
  List<Object> get props => [mobilityStatus];
}
