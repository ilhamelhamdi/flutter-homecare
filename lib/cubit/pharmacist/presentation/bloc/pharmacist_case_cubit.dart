import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacist/domain/usecases/get_pharmacist_cases.dart';
import 'package:m2health/cubit/pharmacist/presentation/bloc/pharmacist_case_state.dart';

class PharmacistCaseCubit extends Cubit<PharmacistCaseState> {
  final GetPharmacistCases getPharmacistCases;

  PharmacistCaseCubit({required this.getPharmacistCases})
      : super(PharmacistCaseInitial());

  Future<void> fetchPharmacistCases() async {
    try {
      emit(PharmacistCaseLoading());
      final cases = await getPharmacistCases();
      emit(PharmacistCaseLoaded(cases));
    } catch (e) {
      emit(PharmacistCaseError(e.toString()));
    }
  }
}
