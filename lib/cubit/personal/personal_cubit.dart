import 'package:bloc/bloc.dart';
import 'personal_state.dart';

class PersonalCubit extends Cubit<PersonalState> {
  PersonalCubit() : super(PersonalInitial());

  void loadPersonalDetails() {
    emit(PersonalLoading());
    // Simulate loading data
    Future.delayed(Duration(seconds: 1), () {
      emit(PersonalLoaded('bedbound'));
    });
  }

  void updateMobilityStatus(String mobilityStatus) {
    emit(PersonalLoaded(mobilityStatus));
  }
}
