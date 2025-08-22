import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/views/details/add_on.dart';

// This structure is used to manage the details of a nursing appointment.
// In backend systems, it corresponds to the NursePersonalCase.
// This structure normalized duplicate data, such mobility status, which is shared across multiple cases.
class NursingBookingIntake extends Equatable {
  final int? appointmentId;
  final String caseType;
  final List<NursingCase> cases;
  final String? mobilityStatus;
  final int? relatedHealthRecordId;
  final List<AddOnService> addOnServices;
  final double estimatedBudget;

  const NursingBookingIntake({
    this.appointmentId,
    required this.caseType,
    required this.cases,
    this.mobilityStatus,
    this.relatedHealthRecordId,
    required this.addOnServices,
    required this.estimatedBudget,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        caseType,
        cases,
        mobilityStatus,
        relatedHealthRecordId,
        addOnServices,
        estimatedBudget,
      ];
}
