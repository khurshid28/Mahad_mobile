import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/result/result_post_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/service/storage_service.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultPostBloc extends Cubit<ResultPostState> {
  DioClient dioClient = DioClient();
  ResultPostBloc() : super(ResultPostIntialState());

  Future post({required int solved, required int test_id}) async {
    emit(ResultPostWaitingState());
    String? token = StorageService().read(StorageService.access_token);
    dio.Response response = await dioClient.post(
      Endpoints.result,
      data: {"test_id": test_id, "solved": solved},

      options: dio.Options(headers: {"Authorization": "Bearer $token"}),
    );
    if (kDebugMode) {
      print(response.realUri);
      print(response.statusCode);
      print(response.data);
    }

    if (response.statusCode == 201) {
      emit(ResultPostSuccessState(data: response.data));
    } else {
      emit(
        ResultPostErrorState(
          title: response.data["error"],
          message: response.data["error"],
          statusCode: response.statusCode,
        ),
      );
    }

    return response.data;
  }
}
