import 'package:dio/dio.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/network/dio_client.dart';
import 'package:test_app/models/special_test.dart';
import 'package:test_app/service/storage_service.dart';

class SpecialTestRepository {
  final DioClient _client = DioClient();

  Future<List<SpecialTest>> getAllSpecialTests() async {
    try {
      print('🟡 [Repository] Calling API: ${Endpoints.baseUrl}${Endpoints.specialTest}/all');
      
      String? token = StorageService().read(StorageService.access_token);
      print('🟡 [Repository] Token: ${token != null ? "exists" : "null"}');
      
      final response = await _client.get(
        "${Endpoints.baseUrl}${Endpoints.specialTest}/all",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        ),
      );

      print('🟢 [Repository] Response status: ${response.statusCode}');
      print('🟢 [Repository] Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('🟢 [Repository] Got ${data.length} items from API');
        if (data.isNotEmpty) {
          print('🟢 [Repository] First item keys: ${(data[0] as Map).keys.toList()}');
        }
        
        final tests = data.map((json) => SpecialTest.fromJson(json)).toList();
        print('🟢 [Repository] Successfully parsed ${tests.length} tests');
        return tests;
      }
      print('🔴 [Repository] Bad status code: ${response.statusCode}');
      return [];
    } catch (e, stack) {
      print('🔴 [Repository] Error: $e');
      print('🔴 [Repository] Stack: $stack');
      throw Exception('Failed to load special tests: $e');
    }
  }

  Future<SpecialTest> getSpecialTest(int id) async {
    try {
      String? token = StorageService().read(StorageService.access_token);
      
      final response = await _client.get(
        "${Endpoints.baseUrl}${Endpoints.specialTest}/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        ),
      );

      if (response.statusCode == 200) {
        return SpecialTest.fromJson(response.data);
      }
      throw Exception('Failed to load special test');
    } catch (e) {
      throw Exception('Failed to load special test: $e');
    }
  }

  Future<SpecialTestResult> submitTest(
      int testId, Map<String, String> answers) async {
    try {
      print('🟡 [Repository] Submitting test $testId with ${answers.length} answers');
      String? token = StorageService().read(StorageService.access_token);
      print('🟡 [Repository] Token: ${token != null ? "exists" : "null"}');
      
      final data = {"answers": answers};
      print('🟡 [Repository] Data to send: $data');
      
      final response = await _client.post(
        "${Endpoints.baseUrl}${Endpoints.specialTest}/$testId/submit",
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        ),
      );

      print('🟢 [Repository] Submit response status: ${response.statusCode}');
      print('🟢 [Repository] Submit response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = SpecialTestResult.fromJson(response.data);
        print('🟢 [Repository] Parsed result: message=${result.message}, id=${result.resultId}');
        return result;
      }
      print('🔴 [Repository] Bad status code: ${response.statusCode}');
      throw Exception('Failed to submit test');
    } catch (e, stack) {
      print('🔴 [Repository] Submit error: $e');
      print('🔴 [Repository] Stack: $stack');
      if (e is DioException && e.response != null) {
        print('🔴 [Repository] Response data: ${e.response?.data}');
        final message = e.response?.data['message'] ?? 'Failed to submit test';
        throw Exception(message);
      }
      throw Exception('Failed to submit test: $e');
    }
  }

  Future<bool> hasStudentTakenTest(int testId, int studentId) async {
    try {
      String? token = StorageService().read(StorageService.access_token);
      
      // Check if student has a result for this test
      final response = await _client.get(
        "${Endpoints.baseUrl}${Endpoints.result}/all",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        return results.any((result) =>
            result['special_test_id'] == testId &&
            result['student_id'] == studentId);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
