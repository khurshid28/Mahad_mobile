import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class SubjectController {
  static Future<void> getAll(BuildContext context) async {
    try {
      await BlocProvider.of<SubjectAllBloc>(context).get();
    } catch (e, track) {
      var err = e as DioExceptions;
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }

      BlocProvider.of<SubjectAllBloc>(
        context,
      ).emit(SubjectAllErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }
}
