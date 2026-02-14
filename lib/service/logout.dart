import 'package:flutter/widgets.dart';
import 'package:test_app/export_files.dart' show MaterialPageRoute;
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/service/storage_service.dart' show StorageService;
import 'package:test_app/service/toast_service.dart';

Future Logout(BuildContext context, {String? message}) async {
  for (var i = 0; i < 20; i++) {
    print("+++++");
  }
  await Future.wait([
    StorageService().remove(StorageService.access_token),
    StorageService().remove(StorageService.user),
  ]);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );

  ToastService toastService = ToastService();
  if (message != null) {
    toastService.success(message: message);
  } else {
    toastService.error(message: "Sessiya tugadi. Qaytadan kiring");
  }
}
