import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/core/network/dio_exception.dart';

import '../export_files.dart';

class BookController {
  static Future<void> getAll(BuildContext context) async {
    try {
      await BlocProvider.of<BookAllBloc>(context).get();
    } catch (e, track) {
      var err = e as DioExceptions;
      if (kDebugMode) {
        print("Controller Error >>$e");
        print("Controller track >>$track");
      }

      BlocProvider.of<BookAllBloc>(
        context,
      ).emit(BookAllErrorState(message: err.message, title: err.message,statusCode: 500));
    }
  }
}
