import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/crud_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_state.dart';

class PharmacogenomicsCubit extends Cubit<PharmacogenomicsState> {
  final GetPharmacogenomics getPharmacogenomics;
  final CreatePharmacogenomic createPharmacogenomic;
  final UpdatePharmacogenomic updatePharmacogenomic;
  final DeletePharmacogenomic deletePharmacogenomic;

  PharmacogenomicsCubit({
    required this.getPharmacogenomics,
    required this.createPharmacogenomic,
    required this.updatePharmacogenomic,
    required this.deletePharmacogenomic,
  }) : super(PharmacogenomicsInitial());

  Future<void> fetchPharmacogenomics() async {
    try {
      emit(PharmacogenomicsLoading());
      final result = await getPharmacogenomics();
      emit(PharmacogenomicsLoaded(result));
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> create(String title, String? description, File? file) async {
    try {
      await createPharmacogenomic(title, description, file);
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> update(
      int id, String title, String? description, File? file) async {
    try {
      await updatePharmacogenomic(id, title, description, file);
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    try {
      await deletePharmacogenomic(id);
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }
}
