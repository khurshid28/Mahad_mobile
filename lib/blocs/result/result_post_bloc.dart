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

  Future post({
    required int solved,
    int? test_id,
    required List answers,
    String? type,
    String? startTime,
    String? finishTime,
  }) async {
    emit(ResultPostWaitingState());
    String? token = StorageService().read(StorageService.access_token);

    final Map<String, dynamic> requestData = {
      "test_id": test_id,
      "solved": solved,
      "answers": answers,
      "type": type,
    };

    if (startTime != null) {
      requestData["startTime"] = startTime;
    }

    if (finishTime != null) {
      requestData["finishTime"] = finishTime;
    }

    dio.Response response = await dioClient.post(
      Endpoints.result,
      data: requestData,
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
