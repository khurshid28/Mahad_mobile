import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/result/result_all_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
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

  BlocProvider<SubjectAllBloc>(
    create: (BuildContext context) => SubjectAllBloc(),
    lazy: false,
  ),

  BlocProvider<BookAllBloc>(
    create: (BuildContext context) => BookAllBloc(),
    lazy: false,
  ),

  BlocProvider<ResultAllBloc>(
    create: (BuildContext context) => ResultAllBloc(),
    lazy: false,
  ),


 BlocProvider<ResultPostBloc>(
    create: (BuildContext context) => ResultPostBloc(),
    lazy: false,
  ),
   BlocProvider<SectionAllBloc>(
    create: (BuildContext context) => SectionAllBloc(),
    lazy: false,
  ),

   BlocProvider<SectionBloc>(
    create: (BuildContext context) => SectionBloc(),
    lazy: false,
  ),
   BlocProvider<RateBloc>(
    create: (BuildContext context) => RateBloc(),
    lazy: false,
  ),
    BlocProvider<TestBloc>(
    create: (BuildContext context) => TestBloc(),
    lazy: false,
  ),
];
