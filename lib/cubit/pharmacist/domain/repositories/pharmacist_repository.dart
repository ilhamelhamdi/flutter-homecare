import 'package:m2health/cubit/pharmacist/domain/entities/pharmacist_case.dart';

abstract class PharmacistRepository {
  Future<List<PharmacistCase>> getPharmacistCases();
}
