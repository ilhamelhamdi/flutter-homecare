import 'package:m2health/cubit/nursing/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/cubit/nursing/data/models/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursing/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursing/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource remoteDataSource;

  NursingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NursingServiceEntity>> getNursingServices() async {
    final nursingServiceModels = await remoteDataSource.getNursingServices();
    return nursingServiceModels;
  }

  @override
  Future<List<NursingCase>> getNursingCases() async {
    final nursingCaseModels = await remoteDataSource.getNursingCases();
    return nursingCaseModels;
  }

  @override
  Future<void> createNursingCase(NursingCase nursingCase) async {
    final nursingCaseModel = NursingCaseModel(
      title: nursingCase.title,
      description: nursingCase.description,
      images: nursingCase.images,
    );
    await remoteDataSource.createNursingCase(nursingCaseModel);
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    return await remoteDataSource.getMedicalRecords();
  }

  @override
  Future<void> updateNursingCase(String id, Map<String, dynamic> data) async {
    await remoteDataSource.updateNursingCase(id, data);
  }

  @override
  Future<List<ProfessionalEntity>> getProfessionals(String serviceType) async {
    final professionals = await remoteDataSource.getProfessionals(serviceType);
    return professionals
        .map((professional) => ProfessionalEntity(
              id: professional['id'] ?? 0,
              name: professional['name'] ?? 'Unknown Provider',
              avatar: professional['avatar'] ?? '',
              experience: professional['experience'] ?? 0,
              rating: (professional['rating'] ?? 0.0).toDouble(),
              about: professional['about'] ?? 'No description available',
              workingInformation: professional['working_information'] ?? '',
              daysHour: professional['days_hour'] ?? 'Not specified',
              mapsLocation:
                  professional['maps_location'] ?? 'Location not available',
              certification: professional['certification'] ?? '',
              userId: professional['user_id'] ?? 0,
              user: professional['user'],
              createdAt: professional['created_at'] ?? '',
              updatedAt: professional['updated_at'] ?? '',
              isFavorite: professional['isFavorite'] ?? false,
              role: professional['role'] ?? 'nurse',
              providerType: professional['provider_type'] ?? 'nurse',
            ))
        .toList();
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    await remoteDataSource.toggleFavorite(professionalId, isFavorite);
  }
}
