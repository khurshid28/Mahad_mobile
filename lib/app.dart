import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390.0, 845.0),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: providers,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Test App',
            theme: ThemeData(primarySwatch: Colors.green),
            home: const SplashScreen(),
          ),
        );
       
      },
    );
  }
}



List<BlocProvider> providers = [

  BlocProvider<AuthBloc>(
    create: (BuildContext context) => AuthBloc(),
    lazy: false,
  ),

];