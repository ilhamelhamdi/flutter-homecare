import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/profile_state.dart';
import 'package:m2health/models/profile.dart';
import 'package:m2health/utils.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio;

  ProfileCubit(this._dio) : super(ProfileLoading());

  Future<void> fetchProfile() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.get(
        '${Const.URL_API}/profiles',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data['data'][0];
        final profile = Profile.fromJson(profileData);
        emit(ProfileLoaded(profile));
      } else if (response.statusCode == 401) {
        emit(ProfileLoaded(Profile(
          id: 0,
          userId: 0,
          email: '',
          username: '',
          age: 0,
          weight: 0,
          height: 0,
          phoneNumber: '',
          homeAddress: '',
          createdAt: '',
          updatedAt: '',
        )));
      } else if (response.statusCode == 401) {
        emit(ProfileUnauthenticated());
      } else {
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.put(
        '${Const.URL_API}/profiles/${profile.id}',
        data: profile.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final updatedProfile = Profile.fromJson(response.data['data']);
        emit(ProfileUpdateSuccess(updatedProfile));
      } else if (response.statusCode == 401) {
        emit(ProfileUnauthenticated());
      } else {
        emit(ProfileError('Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
