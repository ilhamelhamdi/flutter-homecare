import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class SubmitNursingBookingIntake {
  final NursingRepository repository;

  SubmitNursingBookingIntake(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return const Right(unit);
  }
}
