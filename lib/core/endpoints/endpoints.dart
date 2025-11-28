import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static const int receiveTimeout = 20000;
  static const int connectionTimeout = 20000;
  static String baseUrl = dotenv.env["base_url"] ?? "";
  static String domain = dotenv.env["domain"] ?? "";

  static String login = dotenv.env["login"] ?? "";

  static String subject = dotenv.env["subject"] ?? "";
  static String book = dotenv.env["book"] ?? "";
  static String section = dotenv.env["section"] ?? "";
  static String test = dotenv.env["test"] ?? "";


  static String result = dotenv.env["result"] ?? "";

  static String rate = dotenv.env["rate"] ?? "";

  static String specialTest = dotenv.env["special_test"] ?? "";

  
}
