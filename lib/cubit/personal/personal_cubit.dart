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
      print('Token: $token');
      final response = await Dio().get(
        '${Const.API_PERSONAL_CASES}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final issues = data.map((json) => Issue.fromJson(json)).toList();
        print('Parsed issues: $issues');
        emit(PersonalLoaded(issues));
      } else {
        print('Failed to load data: ${response.statusMessage}');
        emit(PersonalError('Failed to load data'));
      }
    } catch (e) {
      print('Error: $e');
      emit(PersonalError(e.toString()));
    }
  }

  void addIssue(Issue issue) async {
    if (state is PersonalLoaded) {
      final currentState = state as PersonalLoaded;
      final updatedIssues = List<Issue>.from(currentState.issues)..add(issue);
      emit(PersonalLoaded(updatedIssues));

      try {
        final token = await Utils.getSpString(Const.TOKEN);
        await Dio().post(
          '${Const.API_PERSONAL_CASES}',
          data: issue.toJson(),
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      } catch (e) {
        emit(PersonalError(e.toString()));
      }
    }
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
