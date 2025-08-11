import 'package:m2health/cubit/pharmacist/data/models/pharmacist_case_model.dart';

abstract class PharmacistRemoteDataSource {
  Future<List<PharmacistCaseModel>> getPharmacistCases();
}
