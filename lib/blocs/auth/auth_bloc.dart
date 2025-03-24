import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/auth/auth_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Cubit<AuthState> {
  DioClient dioClient = DioClient();
  AuthBloc() : super(AuthIntialState());

  Future login({  required String? login,
     required String? password,}) async {
    emit(AuthWaitingState());
    dio.Response response = await dioClient.post(Endpoints.login,
        data: {'login': login,'password' : password}, 
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
            message: response.data["messsage"],
        ),
      );
    } else {
      emit(
        AuthErrorState(
            title: response.data["error"], message: response.data["error"],statusCode: response.statusCode),
      );
    }

    return response.data;
  }
}
