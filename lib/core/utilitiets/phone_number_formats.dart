import 'package:test_app/export_files.dart';

var uzFormat = MaskTextInputFormatter(
  mask: '## ### ## ##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
