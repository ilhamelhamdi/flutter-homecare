import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursingclean/data/models/appointment_model.dart';
import 'package:m2health/utils.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> createAppointment(AppointmentModel data);
}

class AppointmentRemoteDataSourceImpl extends AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl({required this.dio});

  @override
  Future<AppointmentModel> createAppointment(AppointmentModel data) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.post(
      Const.API_APPOINTMENT,
      data: data.toJSON(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return AppointmentModel.fromJSON(response.data['data']['appointment']);
  }
}
