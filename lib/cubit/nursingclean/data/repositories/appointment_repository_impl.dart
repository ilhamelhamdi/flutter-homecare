import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/data/datasources/appointment_remote_datasource.dart';
import 'package:m2health/cubit/nursingclean/data/models/appointment_model.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity data) async {
    try {
      final result = await remoteDataSource.createAppointment(data as AppointmentModel);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
