import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/repositories/nursing_repository.dart';

class GetNursingCases {
  final NursingRepository repository;

  GetNursingCases(this.repository);

  Future<List<NursingCase>> call() async {
    // This is a placeholder. In a real app, you would fetch the cases from the repository.
    return [];
  }
}
