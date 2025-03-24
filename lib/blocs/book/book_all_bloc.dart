import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/service/storage_service.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAllBloc extends Cubit<BookAllState> {
  DioClient dioClient = DioClient();
  BookAllBloc() : super(BookAllIntialState());

  Future get() async {
    emit(BookAllWaitingState());
    String? token  = StorageService().read(StorageService.access_token);
    dio.Response response = await dioClient.get("${Endpoints.book}/all",options: dio.Options(
      headers: {
        "Authorization" :"Bearer $token"
      }
    ));
    if (kDebugMode) {
       print(response.realUri);
      print(response.statusCode);
      print(response.data);
    }

    if (response.statusCode == 200) {
      emit(BookAllSuccessState(data: response.data));
    } else {
      emit(
        BookAllErrorState(
          title: response.data["error"],
          message: response.data["error"],
          statusCode: response.statusCode
        ),
      );
    }

    return response.data;
  }
}
