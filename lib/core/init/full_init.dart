import 'package:test_app/core/init/env/dotenv_init.dart';
import 'package:test_app/core/init/storage/storage_init.dart';
import 'package:test_app/core/init/systemChrome/system_chrome_init.dart';
import 'package:test_app/core/init/widgetBuild/widget_build.dart';

import '../../export_files.dart';
import 'intl/intl_init.dart';

// ignore: non_constant_identifier_names
Future<void> FullInit() async {
  widgetBuildInit();
    await storageInit();
  await SystemChrome_init();
  await dotenvInit();


  // await initLanguages();
  intl_init();
}
