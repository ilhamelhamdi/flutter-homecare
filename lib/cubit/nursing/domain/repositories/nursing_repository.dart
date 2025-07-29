import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_service_entity.dart';

abstract class NursingRepository {
  Future<List<NursingServiceEntity>> getNursingServices();
  Future<void> createNursingCase(NursingCase nursingCase);
}
