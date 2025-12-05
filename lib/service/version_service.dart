import 'package:package_info_plus/package_info_plus.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/network/dio_client.dart';

class AppVersionModel {
  final String version;
  
  AppVersionModel(this.version);
}

class VersionService {
  final DioClient _client = DioClient();

  Future<AppVersionModel> getServerVersion() async {
    try {
      final response = await _client.get(
        "${Endpoints.baseUrl}/version",
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final version = data['version'] as String? ?? '1.0.0';
        return AppVersionModel(version);
      }
      throw Exception('Failed to load version');
    } catch (e) {
      throw Exception('Failed to load version: $e');
    }
  }

  Future<String> getCurrentAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  bool isUpdateRequired(String currentVersion, String serverVersion) {
    try {
      final current = _parseVersion(currentVersion);
      final server = _parseVersion(serverVersion);

      // Compare major.minor.patch
      if (server[0] > current[0]) return true; // Major version difference
      if (server[0] == current[0] && server[1] > current[1]) return true; // Minor version difference
      if (server[0] == current[0] && server[1] == current[1] && server[2] > current[2]) return true; // Patch version difference

      return false;
    } catch (e) {
      print('Version comparison error: $e');
      return false;
    }
  }

  List<int> _parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }
}
