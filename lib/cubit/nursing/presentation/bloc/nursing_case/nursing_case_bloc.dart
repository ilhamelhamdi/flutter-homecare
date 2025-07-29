import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursing/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/usecases/get_nursing_cases.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_state.dart';

class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
  final GetNursingCases getNursingCases;
  final CreateNursingCase createNursingCase;

  NursingCaseBloc({
    required this.getNursingCases,
    required this.createNursingCase,
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
  }
}
