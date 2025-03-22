import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static const int receiveTimeout = 20000;
  static const int connectionTimeout = 20000;
  static String baseUrl = dotenv.env["base_url"] ?? "";
  static String domain = dotenv.env["domain"] ?? "";
 
  static String login = dotenv.env["login"] ?? "";


  

  
  

  
  

  
}
