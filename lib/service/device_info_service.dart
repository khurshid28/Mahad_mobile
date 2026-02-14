import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';
import 'package:get_storage/get_storage.dart';

class DeviceInfoService {
  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    
    if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      final storage = GetStorage();
      
      // Get or generate persistent device UUID for web
      String? deviceUuid = storage.read('device_uuid');
      if (deviceUuid == null) {
        deviceUuid = const Uuid().v4();
        await storage.write('device_uuid', deviceUuid);
      }
      
      final browserName = webInfo.browserName.name;
      final platform = webInfo.platform ?? 'Unknown';
      
      return {
        'device_name': '$browserName on $platform',
        'device_identifier': deviceUuid,
        'device_type': 'WEB',
        'user_agent': webInfo.userAgent ?? 'Unknown',
        'app_version': packageInfo.version,
      };
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'device_name': '${androidInfo.brand} ${androidInfo.model}',
        'device_identifier': androidInfo.id,
        'device_type': 'ANDROID',
        'user_agent': 'Android ${androidInfo.version.release}',
        'app_version': packageInfo.version,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'device_name': '${iosInfo.name} ${iosInfo.model}',
        'device_identifier': iosInfo.identifierForVendor ?? 'unknown',
        'device_type': 'IOS',
        'user_agent': 'iOS ${iosInfo.systemVersion}',
        'app_version': packageInfo.version,
      };
    }
    
    throw UnsupportedError('Platform not supported');
  }
}
