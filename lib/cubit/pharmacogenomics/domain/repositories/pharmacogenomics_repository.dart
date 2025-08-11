import 'dart:io';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

abstract class PharmacogenomicsRepository {
  Future<List<Pharmacogenomics>> getPharmacogenomics();
  Future<Pharmacogenomics> getPharmacogenomicById(int id);
  Future<void> createPharmacogenomic(
      String title, String? description, File? file);
  Future<void> updatePharmacogenomic(
      int id, String title, String? description, File? file);
  Future<void> deletePharmacogenomic(int id);
}
