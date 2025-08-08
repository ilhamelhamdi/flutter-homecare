import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

abstract class PharmacogenomicsState extends Equatable {
  const PharmacogenomicsState();

  @override
  List<Object> get props => [];
}

class PharmacogenomicsInitial extends PharmacogenomicsState {}

class PharmacogenomicsLoading extends PharmacogenomicsState {}

class PharmacogenomicsLoaded extends PharmacogenomicsState {
  final List<Pharmacogenomics> pharmacogenomics;

  const PharmacogenomicsLoaded(this.pharmacogenomics);

  @override
  List<Object> get props => [pharmacogenomics];
}

class PharmacogenomicsError extends PharmacogenomicsState {
  final String message;

  const PharmacogenomicsError(this.message);

  @override
  List<Object> get props => [message];
}
