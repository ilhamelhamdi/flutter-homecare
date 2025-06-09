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

  Future<void> updateProfileWithImage(Profile profile, File? imageFile) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // If no image file, use regular update
      if (imageFile == null) {
        return updateProfile(profile);
      }

      // Create FormData for multipart upload
      FormData formData = FormData.fromMap({
        'age': profile.age,
        'weight': profile.weight,
        'height': profile.height,
        'phone_number': profile.phoneNumber,
        'home_address': profile.homeAddress,
        'gender': profile.gender,
      });

      // Add image file if provided
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ),
      );

      final response = await _dio.put(
        '${Const.URL_API}/profiles/${profile.id}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
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
