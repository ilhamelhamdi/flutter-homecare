// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:m2health/const.dart';
// import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
// import 'package:m2health/utils.dart';

// abstract class NursingRepository {
//   Future<List<NursingCase>> getCases();
//   Future<NursingCase> createCase(
//       {required String title,
//       required String description,
//       required String mobilityStatus,
//       required String careType,
//       required String medicalRequirements,
//       required int relatedHealthRecordId,
//       required List<File> images});
//   Future<void> updateCase(NursingCase nursingCase);
//   Future<void> deleteCase(int id);
// }

// // lib/features/nursing/data/repositories/nursing_repository_impl.dart
// class NursingRepositoryImpl implements NursingRepository {
//   final Dio _dio;

//   NursingRepositoryImpl(this._dio);

//   @override
//   Future<List<NursingCase>> getCases() async {
//     try {
//       final token = await Utils.getSpString(Const.TOKEN);
//       final response = await _dio.get(
//         '${Const.URL_API}/nursing/personal-cases',
//         options: Options(
//           headers: {'Authorization': 'Bearer $token'},
//         ),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data['data'];
//         return data.map((json) => NursingCase.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load nursing cases');
//       }
//     } catch (e) {
//       throw Exception('Error fetching nursing cases: $e');
//     }
//   }

//   @override
//   Future<NursingCase> createCase(
//       {required String title,
//       required String description,
//       required String mobilityStatus,
//       required String careType,
//       required String medicalRequirements,
//       required int relatedHealthRecordId,
//       required List<File> images}) async {
//     try {
//       final token = await Utils.getSpString(Const.TOKEN);

//       // Create form data
//       final formData = FormData.fromMap({
//         'title': title,
//         'description': description,
//         'mobility_status': mobilityStatus,
//         'care_type': careType,
//         'medical_requirements': medicalRequirements,
//         'related_health_record_id': relatedHealthRecordId,
//       });

//       // Add images
//       for (var image in images) {
//         formData.files.add(
//           MapEntry(
//             'images[]',
//             await MultipartFile.fromFile(image.path),
//           ),
//         );
//       }

//       final response = await _dio.post(
//         '${Const.URL_API}/nursing/personal-cases',
//         data: formData,
//         options: Options(
//           headers: {'Authorization': 'Bearer $token'},
//         ),
//       );

//       if (response.statusCode == 201) {
//         return NursingCase.fromJson(response.data['data']);
//       } else {
//         throw Exception('Failed to create nursing case');
//       }
//     } catch (e) {
//       throw Exception('Error creating nursing case: $e');
//     }
//   }
// }
