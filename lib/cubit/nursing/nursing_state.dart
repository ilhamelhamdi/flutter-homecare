import 'package:equatable/equatable.dart';

abstract class NursingState extends Equatable {
  const NursingState();

  @override
  List<Object> get props => [];
}

class NursingInitial extends NursingState {}

class NursingLoading extends NursingState {}

class NursingLoaded extends NursingState {
  final List<Map<String, String>> tenders;

  const NursingLoaded(this.tenders);

  @override
  List<Object> get props => [tenders];
}

class NursingError extends NursingState {
  final String message;

  const NursingError(this.message);

  @override
  List<Object> get props => [message];
}
