import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/device/device_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/network/dio_Client.dart';
import 'package:test_app/models/device_model.dart';
import 'package:test_app/service/storage_service.dart';

class DeviceBloc extends Cubit<DeviceState> {
  DioClient dioClient = DioClient();
  
  DeviceBloc() : super(DeviceInitialState());

  Future<void> fetchMyDevice() async {
    emit(DeviceLoadingState());
    
    try {
      final token = StorageService().read(StorageService.access_token);
      
      dio.Response response = await dioClient.get(
        '${Endpoints.baseUrl}/device/me',
        options: dio.Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      
      if (kDebugMode) {
        print('Device response: ${response.statusCode}');
        print('Device data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final device = DeviceModel.fromJson(response.data);
        emit(DeviceLoadedState(device: device));
      } else {
        emit(DeviceErrorState(message: 'Qurilma ma\'lumotlarini yuklashda xatolik'));
      }
    } on dio.DioException catch (e) {
      if (kDebugMode) {
        print('DioException: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      
      emit(DeviceErrorState(
        message: e.response?.data?["message"] ?? 'Qurilma ma\'lumotlarini yuklashda xatolik',
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(DeviceErrorState(message: 'Noma\'lum xato yuz berdi'));
    }
  }
}
