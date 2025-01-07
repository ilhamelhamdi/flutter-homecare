import 'package:bloc/bloc.dart';
import 'package:flutter_homecare/cubit/nursing/nursing_state.dart';

class NursingCubit extends Cubit<NursingState> {
  NursingCubit() : super(NursingInitial());

  void loadNursingServices() {
    emit(NursingLoading());

    // Simulate a delay for loading data
    Future.delayed(Duration(seconds: 2), () {
      final dummyTenders = [
        {
          'title': 'Primary Nursing',
          'description':
              'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.',
          'imagePath': 'assets/icons/ilu_nurse.png',
          'color': '9AE1FF',
          'opacity': '0.3',
        },
        {
          'title': 'Specialized Nursing Services',
          'description':
              'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros',
          'imagePath': 'assets/icons/ilu_nurse_special.png',
          'color': 'B28CFF',
          'opacity': '0.2',
        },
      ];

      emit(NursingLoaded(dummyTenders));
    });
  }
}
