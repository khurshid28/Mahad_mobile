import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/test/random_test_bloc.dart';
import 'package:test_app/blocs/test/random_test_state.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
import 'package:test_app/blocs/test/test_state.dart';

import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class TestController {

static Future<void> getByid(BuildContext context,{required int id}) async {
    try {
      await BlocProvider.of<TestBloc>(context).get(id : id);
    } catch (e, track) {
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      var err = e as DioExceptions;

      BlocProvider.of<TestBloc>(
        context,
      ).emit(TestErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }



static Future<void> getRandom(BuildContext context,{required int count, required List<int> sections}) async {
    try {
      await BlocProvider.of<RandomTestBloc>(context).get(count: count,sections: sections);
    } catch (e, track) {
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      var err = e as DioExceptions;

      BlocProvider.of<RandomTestBloc>(
        context,
      ).emit(RandomTestErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }

}
