import 'dart:io';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class CreatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  CreatePharmacogenomic(this.repository);

  Future<void> call(
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
    File fullPathReport,
  ) async {
    await repository.createPharmacogenomic(
      gene,
      genotype,
      phenotype,
      medicationGuidance,
      fullPathReport,
    );
  }
}

class UpdatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  UpdatePharmacogenomic(this.repository);

  Future<void> call(
    int id,
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
    File fullPathReport,
  ) async {
    await repository.updatePharmacogenomic(
      id,
      gene,
      genotype,
      phenotype,
      medicationGuidance,
      fullPathReport,
    );
  }
}

class DeletePharmacogenomic {
  final PharmacogenomicsRepository repository;

  DeletePharmacogenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deletePharmacogenomic(id);
  }
}
