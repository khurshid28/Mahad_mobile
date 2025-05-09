import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/result/result_all_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/test/random_test_bloc.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/screens/splash_screen.dart';
import 'package:test_app/widgets/build/build.dart';

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
             builder: MaterialAppCustomBuilder.builder,
          ),
        );
      },
    );
  }
}

List<BlocProvider> providers = [
  BlocProvider<AuthBloc>(
    create: (BuildContext context) => AuthBloc(),
    lazy: true,
  ),

  BlocProvider<SubjectAllBloc>(
    create: (BuildContext context) => SubjectAllBloc(),
    lazy: true,
  ),

  BlocProvider<BookAllBloc>(
    create: (BuildContext context) => BookAllBloc(),
    lazy: true,
  ),

  BlocProvider<ResultAllBloc>(
    create: (BuildContext context) => ResultAllBloc(),
    lazy: true,
  ),


 BlocProvider<ResultPostBloc>(
    create: (BuildContext context) => ResultPostBloc(),
    lazy: true,
  ),
   BlocProvider<SectionAllBloc>(
    create: (BuildContext context) => SectionAllBloc(),
    lazy: false,
  ),

   BlocProvider<SectionBloc>(
    create: (BuildContext context) => SectionBloc(),
    lazy: true,
  ),
   BlocProvider<RateBloc>(
    create: (BuildContext context) => RateBloc(),
    lazy: true,
  ),
    BlocProvider<TestBloc>(
    create: (BuildContext context) => TestBloc(),
    lazy: true,
  ),
  BlocProvider<RandomTestBloc>(
    create: (BuildContext context) => RandomTestBloc(),
    lazy: true,
  ),
];
