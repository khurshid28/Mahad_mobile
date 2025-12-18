import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../core/network/dio_Client.dart';
import '../core/endpoints/endpoints.dart';

class StudentController {
  static DioClient dioClient = DioClient();

  static Future<Map<String, dynamic>?> getMyGroup(BuildContext context) async {
    try {
      final response = await dioClient.get(Endpoints.myGroup);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching my group: $e');
      return null;
    }
  }
}
