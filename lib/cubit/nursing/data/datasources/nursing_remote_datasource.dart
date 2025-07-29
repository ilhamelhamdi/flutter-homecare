import 'package:m2health/cubit/nursing/data/models/nursing_case.dart';
import 'package:m2health/cubit/nursing/data/models/nursing_service.dart';

abstract class NursingRemoteDataSource {
  Future<List<NursingServiceModel>> getNursingServices();
  Future<void> createNursingCase(NursingCaseModel nursingCase);
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  @override
  Future<List<NursingServiceModel>> getNursingServices() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    return [
      const NursingServiceModel(
        title: 'Primary Nursing',
        description:
            'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.',
        imagePath: 'assets/icons/ilu_nurse.png',
        color: '9AE1FF',
        opacity: '0.3',
      ),
      const NursingServiceModel(
        title: 'Specialized Nursing Services',
        description:
            'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros',
        imagePath: 'assets/icons/ilu_nurse_special.png',
        color: 'B28CFF',
        opacity: '0.2',
      ),
    ];
  }

  @override
  Future<void> createNursingCase(NursingCaseModel nursingCase) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
  }
}
