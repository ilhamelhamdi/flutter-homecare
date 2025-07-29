import 'package:m2health/cubit/nursing/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/cubit/nursing/data/models/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursing/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource remoteDataSource;

  NursingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NursingServiceEntity>> getNursingServices() async {
    final nursingServiceModels = await remoteDataSource.getNursingServices();
    return nursingServiceModels;
  }

  @override
  Future<void> createNursingCase(NursingCase nursingCase) async {
    final nursingCaseModel = NursingCaseModel(
      title: nursingCase.title,
      description: nursingCase.description,
      images: nursingCase.images,
    );
    await remoteDataSource.createNursingCase(nursingCaseModel);
  }
}
