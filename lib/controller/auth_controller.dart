import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/blocs/auth/auth_state.dart';
import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class AuthController {
  static Future<void> login(
    BuildContext context, {
    required String? login,
     required String? password,
  }) async {
    try {
      await BlocProvider.of<AuthBloc>(context).login(
        login: login,
        password: password,
      );
    } catch (e, track) {
      var err = e as DioExceptions;
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      
      BlocProvider.of<AuthBloc>(context).emit(AuthErrorState(message: err.message, title: err.message,statusCode: 500));

    }
  }

  
}
