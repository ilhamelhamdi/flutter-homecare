import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';

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

class GetMedicalRecordsEvent extends NursingCaseEvent {}

class UpdateNursingCaseEvent extends NursingCaseEvent {
  final String caseId;
  final Map<String, dynamic> data;

  const UpdateNursingCaseEvent(this.caseId, this.data);

  @override
  List<Object> get props => [caseId, data];
}
