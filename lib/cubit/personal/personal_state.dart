import 'package:equatable/equatable.dart';

class Issue {
  final String title;
  final String description;
  final List<String> images;

  Issue({
    required this.title,
    required this.description,
    this.images = const [],
  });
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
