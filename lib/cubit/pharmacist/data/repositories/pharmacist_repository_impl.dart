import 'package:m2health/cubit/pharmacist/data/datasources/pharmacist_remote_datasource.dart';
import 'package:m2health/cubit/pharmacist/domain/entities/pharmacist_case.dart';
import 'package:m2health/cubit/pharmacist/domain/repositories/pharmacist_repository.dart';

class PharmacistRepositoryImpl implements PharmacistRepository {
  final PharmacistRemoteDataSource remoteDataSource;

  PharmacistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PharmacistCase>> getPharmacistCases() async {
    final pharmacistCaseModels = await remoteDataSource.getPharmacistCases();
    return pharmacistCaseModels;
  }
}
