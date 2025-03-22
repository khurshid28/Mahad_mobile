



 import 'package:flutter_dotenv/flutter_dotenv.dart';

dotenvInit()async{
  await dotenv.load(fileName: ".env");

}