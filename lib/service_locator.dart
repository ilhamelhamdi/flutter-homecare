import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/medical_record/injection.dart';
import 'package:m2health/cubit/nursingclean/injection.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External Dependencies (like Dio, SharedPreferences, etc.)
  sl.registerLazySingleton(() => Dio());

  // Feature Module Injectors
  initNursingModule(sl);
  initMedicalRecordModule(sl);
}
