import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/data/models/nursing_case.dart';
import 'package:m2health/cubit/nursing/data/models/nursing_service.dart';
import 'package:m2health/utils.dart';

abstract class NursingRemoteDataSource {
  Future<List<NursingServiceModel>> getNursingServices();
  Future<void> createNursingCase(NursingCaseModel nursingCase);
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getProfessionals(String serviceType);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  final Dio dio;

  NursingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NursingServiceModel>> getNursingServices() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_NURSE_SERVICES,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final services = (response.data['data'] as List)
          .map((service) => NursingServiceModel.fromMap(service))
          .toList();
      return services;
    } else {
      throw Exception('Failed to load nursing services');
    }
  }

  @override
  Future<void> createNursingCase(NursingCaseModel nursingCase) async {
    // This can be implemented later if needed
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_MEDICAL_RECORDS,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception('Failed to fetch medical records');
    }
  }

  @override
  Future<void> updateNursingCase(String id, Map<String, dynamic> data) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final url = '${Const.API_PERSONAL_CASES}/$id';

    final response = await dio.put(
      url,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update issue: ${response.statusMessage}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getProfessionals(
      String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    String apiEndpoint;
    if (serviceType.toLowerCase() == "pharma" ||
        serviceType.toLowerCase() == "pharmacist") {
      apiEndpoint = Const.API_PHARMACIST_SERVICES;
    } else if (serviceType.toLowerCase() == "nurse") {
      apiEndpoint = Const.API_NURSE_SERVICES;
    } else if (serviceType.toLowerCase() == "radiologist") {
      apiEndpoint = Const.API_RADIOLOGIST_SERVICES;
    } else {
      throw Exception('Unknown service type: $serviceType');
    }

    final response = await dio.get(
      apiEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      List<dynamic> professionalList = [];

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          professionalList = responseData['data'] ?? [];
        } else {
          professionalList = [responseData];
        }
      } else if (responseData is List) {
        professionalList = responseData;
      }
      return professionalList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data: HTTP ${response.statusCode}');
    }
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    final userId = await Utils.getSpString(Const.USER_ID);
    final token = await Utils.getSpString(Const.TOKEN);

    if (isFavorite) {
      final data = {
        'user_id': userId,
        'item_id': professionalId,
        'item_type': 'nurse', // Assuming nurse for now
        'highlighted': 1,
      };
      final response = await dio.post(
        Const.API_FAVORITES,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update favorite status');
      }
    } else {
      final data = {
        'user_id': userId,
        'item_id': professionalId,
        'item_type': 'nurse',
      };
      final response = await dio.delete(
        Const.API_FAVORITES,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete favorite');
      }
    }
  }
}
