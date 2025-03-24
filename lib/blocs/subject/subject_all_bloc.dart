import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/service/storage_service.dart';
import '../../core/network/dio_Client.dart';
import '../../export_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectAllBloc extends Cubit<SubjectAllState> {
  DioClient dioClient = DioClient();
  SubjectAllBloc() : super(SubjectAllIntialState());

  Future get() async {
    emit(SubjectAllWaitingState());
    String? token  = StorageService().read(StorageService.access_token);
    dio.Response response = await dioClient.get("${Endpoints.subject}/all",options: dio.Options(
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
      emit(SubjectAllSuccessState(data: response.data));
    } else {
      emit(
        SubjectAllErrorState(
          title: response.data["error"],
          message: response.data["error"],
          statusCode: response.statusCode
        ),
      );
    }

    return response.data;
  }
}
