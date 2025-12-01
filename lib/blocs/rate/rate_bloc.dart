import 'package:dio/dio.dart' as dio;
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
    try {
      print("🟡 [RateBloc] Starting rate fetch...");
      emit(RateWaitingState());
      
      String? token = StorageService().read(StorageService.access_token);
      print("🟡 [RateBloc] Token: ${token != null ? 'Found' : 'Missing'}");
      print("🟡 [RateBloc] Endpoint: ${Endpoints.rate}");
      
      dio.Response response = await dioClient.get(
        "${Endpoints.rate}",
        options: dio.Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      
      print("🟢 [RateBloc] Response received:");
      print("🟢 [RateBloc] URL: ${response.realUri}");
      print("🟢 [RateBloc] Status Code: ${response.statusCode}");
      print("🟢 [RateBloc] Data Type: ${response.data.runtimeType}");
      print("🟢 [RateBloc] Data: ${response.data}");

      if (response.statusCode == 200) {
        print("🟢 [RateBloc] Success - Emitting RateSuccessState");
        emit(RateSuccessState(data: response.data ?? []));
      } else {
        print("🔴 [RateBloc] Error response - Status: ${response.statusCode}");
        emit(
          RateErrorState(
            title: response.data?["error"] ?? "Xatolik",
            message: response.data?["error"] ?? "Ma'lumot yuklanmadi",
            statusCode: response.statusCode,
          ),
        );
      }

      return response.data;
    } catch (e, stackTrace) {
      print("🔴 [RateBloc] Exception caught:");
      print("🔴 [RateBloc] Error: $e");
      print("🔴 [RateBloc] Error Type: ${e.runtimeType}");
      print("🔴 [RateBloc] Stack Trace: $stackTrace");
      
      emit(
        RateErrorState(
          title: "Xatolik",
          message: "Liderlar ma'lumotini yuklab bo'lmadi: $e",
          statusCode: 500,
        ),
      );
      return null;
    }
  }
}
