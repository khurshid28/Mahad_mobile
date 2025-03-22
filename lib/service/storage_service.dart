import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage box = GetStorage();

  read(String key) {
    return box.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    await box.write(key, value);
  }

  Future remove(String key) async {
    await box.remove(key);
  }


  static String access_token = 'access_token';
  static String user = 'user';

  

  
}
