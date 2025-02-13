import 'package:bloc/bloc.dart';
import 'personal_state.dart';

class PersonalCubit extends Cubit<PersonalState> {
  PersonalCubit() : super(PersonalInitial());

  void loadPersonalDetails() {
    emit(PersonalLoading());
    // Simulate loading data
    Future.delayed(Duration(seconds: 1), () {
      final issues = [
        Issue(
          title: 'Issue 1',
          description: 'Description for issue 1',
          images: ['assets/image1.png', 'assets/image2.png'],
        ),
        Issue(
          title: 'Issue 2',
          description: 'Description for issue 2',
        ),
      ];
      emit(PersonalLoaded(issues));
    });
  }

  void updateIssues(List<Issue> issues) {
    emit(PersonalLoaded(issues));
  }

  void deleteIssue(int index) {
    if (state is PersonalLoaded) {
      final currentState = state as PersonalLoaded;
      final updatedIssues = List<Issue>.from(currentState.issues)
        ..removeAt(index);
      emit(PersonalLoaded(updatedIssues));
    }
  }
}
