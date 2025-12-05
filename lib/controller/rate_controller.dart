import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/rate/rate_state.dart';

import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class RateController {
  static Future<void> getAll(BuildContext context) async {
    try {
      await BlocProvider.of<RateBloc>(context).get();
    } catch (e, track) {
     if (e is DioExceptions) {
        var err = e;
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }

      BlocProvider.of<RateBloc>(
        context,
      ).emit(RateErrorState(message: err.message, title: err.message,statusCode: 500));
     }
    }
  }
}
