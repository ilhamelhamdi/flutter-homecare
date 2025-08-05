import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/profile_state.dart';
import 'package:m2health/models/profile.dart';
import 'package:m2health/utils.dart';
import 'dart:io';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio;

  ProfileCubit(this._dio) : super(ProfileLoading());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());
      final token = await Utils.getSpString(Const.TOKEN);

      if (token == null) {
        emit(ProfileUnauthenticated());
        return;
      }

      final response = await _dio.get(
        '${Const.URL_API}/profiles',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data['data'];
        if (profileData is Map<String, dynamic>) {
          final profile = Profile.fromJson(profileData);
          emit(ProfileLoaded(profile));
        } else {
          emit(ProfileError('Unexpected response format'));
        }
      } else if (response.statusCode == 401) {
        emit(ProfileUnauthenticated());
      } else {
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 401) {
        emit(ProfileUnauthenticated());
      } else {
        emit(ProfileError(e.toString()));
      }
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

  Future<void> updateProfileWithImage(Profile profile, File? image) async {
    try {
      // emit(ProfileUpdating());

      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        emit(ProfileError('Authentication token not found.'));
        return;
      }

      final formData = FormData();

      // Add profile data fields
      formData.fields.addAll([
        MapEntry('age', profile.age.toString()),
        MapEntry('gender', profile.gender),
        MapEntry('weight', profile.weight.toString()),
        MapEntry('height', profile.height.toString()),
        MapEntry('phone_number', profile.phoneNumber),
        MapEntry('home_address', profile.homeAddress),
      ]);

      // Add image if selected
      if (image != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            image.path,
            filename: 'avatar.jpg',
          ),
        ));
      }

      final response = await _dio.put(
        '${Const.BASE_URL}/v1/profiles',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Update the profile with the response data
        final updatedProfileData = response.data;
        final updatedProfile = Profile.fromJson(updatedProfileData);

        // Save to local storage if needed
        await Utils.setProfile(Profile.fromJson(updatedProfileData));

        emit(ProfileUpdateSuccess(updatedProfile));
      } else {
        final errorData = response.data;
        final errorMessage =
            errorData['message'] ?? 'Failed to update profile.';
        emit(ProfileError(errorMessage));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
