import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursing/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/usecases/get_nursing_cases.dart';
import 'package:m2health/cubit/nursing/domain/usecases/get_medical_records.dart';
import 'package:m2health/cubit/nursing/domain/usecases/update_nursing_case.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_state.dart';

class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
  final GetNursingCases getNursingCases;
  final CreateNursingCase createNursingCase;
  final GetMedicalRecords getMedicalRecords;
  final UpdateNursingCase updateNursingCase;

  NursingCaseBloc({
    required this.getNursingCases,
    required this.createNursingCase,
    required this.getMedicalRecords,
    required this.updateNursingCase,
  }) : super(NursingCaseInitial()) {
    on<GetNursingCasesEvent>((event, emit) async {
      emit(NursingCaseLoading());
      final nursingCases = await getNursingCases();
      emit(NursingCaseLoaded(nursingCases));
    });

    on<CreateNursingCaseEvent>((event, emit) async {
      emit(NursingCaseLoading());
      await createNursingCase(event.nursingCase);
      final nursingCases = await getNursingCases();
      emit(NursingCaseLoaded(nursingCases));
    });

    on<GetMedicalRecordsEvent>((event, emit) async {
      emit(MedicalRecordsLoading());
      try {
        final medicalRecords = await getMedicalRecords();
        emit(MedicalRecordsLoaded(medicalRecords));
      } catch (e) {
        emit(MedicalRecordsError(e.toString()));
      }
    });

    on<UpdateNursingCaseEvent>((event, emit) async {
      emit(NursingCaseLoading());
      try {
        await updateNursingCase(event.caseId, event.data);
        final nursingCases = await getNursingCases();
        emit(NursingCaseLoaded(nursingCases));
      } catch (e) {
        emit(NursingCaseError(e.toString()));
      }
    });
  }
}
