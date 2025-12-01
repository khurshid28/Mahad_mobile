import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_all_bloc.dart';
import 'package:test_app/blocs/result/result_all_state.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/result/result_post_state.dart';

import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class ResultController {
  static Future<void> getAll(BuildContext context) async {
    try {
      await BlocProvider.of<ResultAllBloc>(context).get();
    } catch (e, track) {
      var err = e as DioExceptions;
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }

      BlocProvider.of<ResultAllBloc>(context).emit(
        ResultAllErrorState(
          message: err.message,
          title: err.message,
          statusCode: 500,
        ),
      );
    }
  }

  static Future<void> post(
    BuildContext context, {
    required int solved,
    int? test_id,
    required List answers,
    String? type,
    String? startTime,
    String? finishTime,
  }) async {
    try {
      await BlocProvider.of<ResultPostBloc>(context).post(
        solved: solved,
        test_id: test_id,
        answers: answers,
        type: type,
        startTime: startTime,
        finishTime: finishTime,
      );
    } catch (e, track) {
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      var err = e as DioExceptions;

      BlocProvider.of<ResultPostBloc>(context).emit(
        ResultPostErrorState(
          message: err.message,
          title: err.message,
          statusCode: 500,
        ),
      );
    }
  }
}
