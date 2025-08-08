import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursing/domain/entities/professional_entity.dart';

abstract class NursingRepository {
  Future<List<NursingServiceEntity>> getNursingServices();
  Future<List<NursingCase>> getNursingCases();
  Future<void> createNursingCase(NursingCase nursingCase);
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<List<ProfessionalEntity>> getProfessionals(String serviceType);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}
