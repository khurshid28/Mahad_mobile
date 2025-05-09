import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import '../../core/endpoints/endpoints.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/storage_service.dart';
import 'random_test_state.dart';

class RandomTestBloc extends Cubit<RandomTestState> {
  DioClient dioClient = DioClient();
  RandomTestBloc() : super(RandomTestIntialState());

  Future get({required int count, required List<int> sections}) async {
    emit(RandomTestWaitingState());
    String? token = StorageService().read(StorageService.access_token);
    dio.Response response = await dioClient.post(
      "${Endpoints.test}/random",
      data: {"count": count, "sections": sections},

      options: dio.Options(headers: {"Authorization": "Bearer $token"}),
    );
    if (kDebugMode) {
      print(response.realUri);
      print(response.statusCode);
      print(response.data);
    }

    if (response.statusCode == 200) {
      emit(
        RandomTestSuccessState(
          data: response.data["data"],
          id: response.data["id"],
        ),
      );
    } else {
      emit(
        RandomTestErrorState(
          title: response.data["error"],
          message: response.data["error"],
          statusCode: response.statusCode,
        ),
      );
    }

    return response.data;
  }
}
