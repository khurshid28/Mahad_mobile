import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../core/network/dio_Client.dart';
import '../core/endpoints/endpoints.dart';
import '../service/storage_service.dart';

class StudentController {
  static DioClient dioClient = DioClient();

  static Future<Map<String, dynamic>?> getMyGroup(BuildContext context) async {
    print('🔵 [StudentController] getMyGroup() chaqirildi');
    print('🔵 [StudentController] Endpoint: ${Endpoints.myGroup}');
    
    String? token = StorageService().read(StorageService.access_token);
    print('🔵 [StudentController] Token: ${token != null ? "mavjud" : "yo\'q"}');
    
    try {
      final response = await dioClient.get(
        Endpoints.myGroup,
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        ),
      );
      print('🔵 [StudentController] Response statusCode: ${response.statusCode}');
      print('🔵 [StudentController] Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      print('⚠️ [StudentController] Status code 200 emas: ${response.statusCode}');
      return null;
    } catch (e) {
      print('🔴 [StudentController] Error fetching my group: $e');
      return null;
    }
  }
}
