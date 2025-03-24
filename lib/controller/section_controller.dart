import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/blocs/section/section_bloc.dart';
import 'package:test_app/blocs/section/section_state.dart';

import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class SectionController {
  static Future<void> getAll(BuildContext context) async {
    try {
      await BlocProvider.of<SectionAllBloc>(context).get();
    } catch (e, track) {
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      var err = e as DioExceptions;

      BlocProvider.of<SectionAllBloc>(
        context,
      ).emit(SectionAllErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }


static Future<void> getByid(BuildContext context,{required int id}) async {
    try {
      await BlocProvider.of<SectionBloc>(context).get(id : id);
    } catch (e, track) {
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }
      var err = e as DioExceptions;

      BlocProvider.of<SectionBloc>(
        context,
      ).emit(SectionErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }

}
