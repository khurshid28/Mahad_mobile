import 'package:flutter/material.dart';
import 'package:test_app/app.dart';
import 'package:test_app/core/init/full_init.dart';

void main() async {
  await FullInit();
  runApp(const MyApp());
}
