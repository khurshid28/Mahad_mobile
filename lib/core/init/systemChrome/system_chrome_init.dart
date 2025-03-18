// ignore_for_file: file_names

import 'package:flutter/services.dart';

// ignore: non_constant_identifier_names
Future<void> SystemChrome_init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.dark,
  //     statusBarColor: Colors.white,
  //   ),
  // );
}
