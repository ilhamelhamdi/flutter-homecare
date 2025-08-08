import 'dart:io';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class CreatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  CreatePharmacogenomic(this.repository);

  Future<void> call(String title, String? description, File? file) async {
    await repository.createPharmacogenomic(title, description, file);
  }
}

class UpdatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  UpdatePharmacogenomic(this.repository);

  Future<void> call(
      int id, String title, String? description, File? file) async {
    await repository.updatePharmacogenomic(id, title, description, file);
  }
}

class DeletePharmacogenomic {
  final PharmacogenomicsRepository repository;

  DeletePharmacogenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deletePharmacogenomic(id);
  }
}
