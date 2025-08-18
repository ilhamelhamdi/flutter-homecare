import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class CreateNursingCase {
  final NursingRepository repository;

  CreateNursingCase(this.repository);

  Future<void> call(NursingCase nursingCase) async {
    await repository.createNursingCase(nursingCase);
  }
}
