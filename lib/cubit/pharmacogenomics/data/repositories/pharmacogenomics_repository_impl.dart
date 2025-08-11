import 'dart:io';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class PharmacogenomicsRepositoryImpl implements PharmacogenomicsRepository {
  final PharmacogenomicsRemoteDataSource remoteDataSource;

  PharmacogenomicsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pharmacogenomics>> getPharmacogenomics() async {
    return await remoteDataSource.getPharmacogenomics();
  }

  @override
  Future<Pharmacogenomics> getPharmacogenomicById(int id) async {
    return await remoteDataSource.getPharmacogenomicById(id);
  }

  @override
  Future<void> createPharmacogenomic(
      String title, String? description, File? file) async {
    await remoteDataSource.createPharmacogenomic(title, description, file);
  }

  @override
  Future<void> updatePharmacogenomic(
      int id, String title, String? description, File? file) async {
    await remoteDataSource.updatePharmacogenomic(id, title, description, file);
  }

  @override
  Future<void> deletePharmacogenomic(int id) async {
    await remoteDataSource.deletePharmacogenomic(id);
  }
}
