import 'package:m2health/cubit/nursing/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursing/domain/repositories/nursing_repository.dart';

class GetNursingServices {
  final NursingRepository repository;

  GetNursingServices(this.repository);

  Future<List<NursingServiceEntity>> call() async {
    return await repository.getNursingServices();
  }
}
