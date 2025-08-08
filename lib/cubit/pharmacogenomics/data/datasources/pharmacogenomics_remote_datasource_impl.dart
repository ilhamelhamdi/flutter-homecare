import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/cubit/pharmacogenomics/data/models/pharmacogenomics_model.dart';
import 'package:m2health/utils.dart';

class PharmacogenomicsRemoteDataSourceImpl
    implements PharmacogenomicsRemoteDataSource {
  final Dio dio;

  PharmacogenomicsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PharmacogenomicsModel>> getPharmacogenomics() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_PHARMACOGENOMICS,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map((item) => PharmacogenomicsModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pharmacogenomics data');
    }
  }

  @override
  Future<PharmacogenomicsModel> getPharmacogenomicById(int id) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      '${Const.API_PHARMACOGENOMICS}/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return PharmacogenomicsModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load pharmacogenomic data');
    }
  }

  @override
  Future<void> createPharmacogenomic(
      String title, String? description, File? file) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      if (file != null) 'file': await MultipartFile.fromFile(file.path),
    });

    await dio.post(
      Const.API_PHARMACOGENOMICS,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> updatePharmacogenomic(
      int id, String title, String? description, File? file) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      if (file != null) 'file': await MultipartFile.fromFile(file.path),
    });

    await dio.put(
      '${Const.API_PHARMACOGENOMICS}/$id',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> deletePharmacogenomic(int id) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await dio.delete(
      '${Const.API_PHARMACOGENOMICS}/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
