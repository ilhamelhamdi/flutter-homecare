import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';

abstract class NursingCaseState extends Equatable {
  const NursingCaseState();

  @override
  List<Object> get props => [];
}

class NursingCaseInitial extends NursingCaseState {}

class NursingCaseLoading extends NursingCaseState {}

class NursingCaseLoaded extends NursingCaseState {
  final List<NursingCase> nursingCases;

  const NursingCaseLoaded(this.nursingCases);

  @override
  List<Object> get props => [nursingCases];
}

class NursingCaseError extends NursingCaseState {
  final String message;

  const NursingCaseError(this.message);

  @override
  List<Object> get props => [message];
}
