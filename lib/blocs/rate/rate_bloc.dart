import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/rate/rate_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/service/storage_service.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateBloc extends Cubit<RateState> {
  DioClient dioClient = DioClient();
  RateBloc() : super(RateIntialState());

  Future get() async {
    emit(RateWaitingState());
    String? token  = StorageService().read(StorageService.access_token);
    dio.Response response = await dioClient.get("${Endpoints.rate}",options: dio.Options(
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
      emit(RateSuccessState(data: response.data));
    } else {
      emit(
        RateErrorState(
          title: response.data["error"],
          message: response.data["error"],
          statusCode: response.statusCode
        ),
      );
    }

    return response.data;
  }
}
