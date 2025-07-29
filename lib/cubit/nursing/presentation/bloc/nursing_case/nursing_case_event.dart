import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';

abstract class NursingCaseEvent extends Equatable {
  const NursingCaseEvent();

  @override
  List<Object> get props => [];
}

class GetNursingCasesEvent extends NursingCaseEvent {}

class CreateNursingCaseEvent extends NursingCaseEvent {
  final NursingCase nursingCase;

  const CreateNursingCaseEvent(this.nursingCase);

  @override
  List<Object> get props => [nursingCase];
}
