// lib/features/nursing/data/datasources/nursing_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/utils.dart';

class NursingRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  NursingRemoteDataSource({required this.dio, required this.baseUrl});

  Future<List<NursingCaseModel>> getNursingCases() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.get(
        '$baseUrl/nursing-cases',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => NursingCaseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nursing cases');
      }
    } catch (e) {
      throw Exception('Error fetching nursing cases: $e');
    }
  }

  Future<NursingCaseModel> createNursingCase(NursingCase nursingCase) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.post(
        '$baseUrl/nursing-cases',
        data: (nursingCase as NursingCaseModel).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return NursingCaseModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create nursing case');
      }
    } catch (e) {
      throw Exception('Error creating nursing case: $e');
    }
  }
}
