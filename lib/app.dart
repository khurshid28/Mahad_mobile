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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Test App',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const SplashScreen(),
        );
        // return BlocProvider(
        //   create: (context) => AuthBloc(),
        //   child: MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     title: 'Test App',
        //     theme: ThemeData(
        //       primarySwatch: Colors.green,
        //     ),
        //     home: const SplashScreen(),
        //   ),
        // );
      },
    );
  }
}
