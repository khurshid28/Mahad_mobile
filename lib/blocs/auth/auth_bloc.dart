import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/auth/auth_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/service/device_info_service.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Cubit<AuthState> {
  DioClient dioClient = DioClient();
  DeviceInfoService deviceInfoService = DeviceInfoService();
  
  AuthBloc() : super(AuthIntialState());

  Future login({  required String? login,
     required String? password,}) async {
    emit(AuthWaitingState());
    
    try {
      // Get device info
      final deviceInfo = await deviceInfoService.getDeviceInfo();
      
      dio.Response response = await dioClient.post(Endpoints.login,
          data: {
            'login': login,
            'password': password,
            'device': deviceInfo,
          }, 
      );
      
      if (kDebugMode) {
        print(response.statusCode);
        print(response.data);
      }

      if (response.statusCode == 200) {
        emit(
          AuthSuccessState(
            user: response.data["user"],
            access_token: response.data["access_token"],
            message: response.data["message"],
          ),
        );
      } else {
        emit(
          AuthErrorState(
              title: response.data["error"] ?? "Xato", 
              message: response.data["message"] ?? response.data["error"] ?? "Noma'lum xato",
              statusCode: response.statusCode),
        );
      }

      return response.data;
    } on dio.DioException catch (e) {
      if (kDebugMode) {
        print('DioException: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      
      // Handle 426 Upgrade Required
      if (e.response?.statusCode == 426) {
        final message = e.response?.data['message'] ?? "Iltimos, ilovaning oxirgi versiyasini yuklab oling";
        emit(AuthUpdateRequiredState(message: message));
        return;
      }
      
      // Handle 403 Forbidden (Device Blocked)
      if (e.response?.statusCode == 403) {
        final message = e.response?.data['message'] ?? "Qurilma bloklangan. Admin bilan bog'laning";
        emit(
          AuthErrorState(
            title: 'Qurilma bloklangan',
            message: message,
            statusCode: e.response?.statusCode,
          ),
        );
        return;
      }
      
      emit(
        AuthErrorState(
          title: 'Xato',
          message: e.response?.data?["message"] ?? e.message ?? 'Noma\'lum xato',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(
        AuthErrorState(
          title: 'Xato',
          message: 'Noma\'lum xato yuz berdi',
          statusCode: null,
        ),
      );
    }
  }
}
