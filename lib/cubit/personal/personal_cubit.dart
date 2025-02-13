import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'personal_state.dart';

class PersonalCubit extends Cubit<PersonalState> {
  PersonalCubit() : super(PersonalInitial());

  void loadPersonalDetails() async {
    emit(PersonalLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().get(
        '${Const.API_PERSONAL_CASES}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final issues = data.map((json) => Issue.fromJson(json)).toList();
        emit(PersonalLoaded(issues));
      } else {
        emit(PersonalError('Failed to load data'));
      }
    } catch (e) {
      emit(PersonalError(e.toString()));
    }
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
