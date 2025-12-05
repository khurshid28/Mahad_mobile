// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:test_app/core/const/const.dart';
// import 'package:test_app/models/subject.dart';
// import 'package:test_app/widgets/subject_card.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Subject> subjects = [
//     Subject(name: "Tarix", imagePath: "assets/images/history.png"),
//     Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
//     Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
//   ];

//   final List<Color> backgroundColors = [
//     Color(0xFFEAF8E5), // Yashil fon
//     Color(0xFFFFF0E5), // Apelsin fon
//     Color(0xFFFFE5E5), // Qizil fon
//   ];

//   final List<Color> borderColors = [
//     Color(0xFF4CAF50), // Yashil ramka (Tarix)
//     Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
//     Color(0xFFF44336), // Qizil ramka (Matematika)
//   ];

//   List<Subject> filteredSubjects = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredSubjects = subjects;
//   }

//   void _filterSubjects(String query) {
//     setState(() {
//       filteredSubjects = subjects
//           .where((subject) =>
//               subject.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppConstant.whiteColor,
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: _filterSubjects,
//               decoration: InputDecoration(
//                 hintText: "Fan qidirish",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.9,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: filteredSubjects.length,
//                 itemBuilder: (context, index) {
//                   return SubjectCard(
//                     subject: filteredSubjects[index],
//                     backgroundColor: backgroundColors[index % backgroundColors.length],
//                     borderColor: borderColors[index % borderColors.length],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/rate/rate_state.dart';
import 'package:test_app/blocs/special_test/special_test_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/controller/rate_controller.dart';
import 'package:test_app/controller/subject_controller.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/books_screen.dart';
import 'package:test_app/screens/rate/rate_screen.dart';
import 'package:test_app/screens/special_test/special_test_list_screen.dart';
import 'package:test_app/screens/special_test/special_test_detail_screen.dart'
    as detail;
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/subject_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<Subject> subjects = [
  //   Subject(name: "Tarix", imagePath: "assets/images/history.png"),
  //   Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
  //   Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
  //   Subject(name: "Tarix", imagePath: "assets/images/history.png"),
  //   Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
  //   Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
  //   Subject(name: "Tarix", imagePath: "assets/images/history.png"),
  //   Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
  //   Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
  // ];

  // final List<Color> backgroundColors = [
  //   Color(0xFFEAF8E5), // Yashil fon
  //   Color(0xFFFFF0E5), // Apelsin fon
  //   Color(0xFFFFE5E5), // Qizil fon
  // ];

  // final List<Color> borderColors = [
  //   Color(0xFF4CAF50), // Yashil ramka (Tarix)
  //   Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
  //   Color(0xFFF44336), // Qizil ramka (Matematika)
  // ];

  num getPercent(List results) {
    double score = 0;
    int totalTests = 0;

    if (results.isEmpty) return 0;

    for (var r in results) {
      try {
        if (r["type"] == "RANDOM") {
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = ((r["answers"] ?? []) as List).length;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        } else if (r["type"] == "SPECIAL") {
          // Maxsus testlar
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = ((r["answers"] ?? []) as List).length;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        } else {
          // Oddiy testlar
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = r["test"]?["_count"]?["test_items"] ?? 1;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    }

    if (totalTests == 0) return 0;
    return (score * 1000 / totalTests).floor() / 10;
  }

  List sortRates(List data) {
    data.sort(
      (a, b) => getPercent(b["results"]).compareTo(getPercent(a["results"])),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    SubjectController.getAll(context);
    RateController.getAll(context);
    context.read<SpecialTestBloc>().add(LoadSpecialTests());
  }

  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // Flexible update boshlash
        // await InAppUpdate.startFlexibleUpdate();

        // // Yuklab bo‘lingach darhol o‘rnatish
        // await InAppUpdate.completeFlexibleUpdate();

        await InAppUpdate.performImmediateUpdate();

        debugPrint("Update completed and app restarting...");
      }
    } catch (e) {
      debugPrint("Update check error: $e");
    }
  }

  List _filterSubjects(List subjects) {
    return subjects
        .where(
          (subject) => subject["name"].toLowerCase().contains(
            seachController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  TextEditingController seachController = TextEditingController();
  ToastService toastService = ToastService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: AppConstant.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                cursorColor: AppConstant.primaryColor,
                onChanged: (value) => setState(() {}),
                controller: seachController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  filled: true,
                  hintText: "Fan qidirish",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 17.w, right: 12.w),
                    child: Icon(
                      Icons.search,
                      color: AppConstant.primaryColor,
                      size: 24.w,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: AppConstant.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<RateBloc, RateState>(
                    builder: (context, state) {
                      int myRate = 0;
                      if (state is RateSuccessState && state.data.isNotEmpty) {
                        final data = sortRates(state.data);
                        Map? user = StorageService().read(StorageService.user);
                        int myIndex = data.indexWhere(
                          (element) =>
                              element["id"].toString() == "${user?["id"]}",
                        );
                        myRate = myIndex == -1 ? 0 : myIndex + 1;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstant.accentOrange,
                              AppConstant.accentOrange.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstant.accentOrange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RateScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                                horizontal: 16.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Liderlar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  if (myRate > 0) ...[
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Text(
                                        myRate.toString(),
                                        style: TextStyle(
                                          color: AppConstant.accentOrange,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: BlocBuilder<SpecialTestBloc, SpecialTestState>(
                    builder: (context, state) {
                      int testCount = 0;
                      if (state is SpecialTestsLoaded) {
                        testCount =
                            state.tests
                                .where(
                                  (test) =>
                                      test.isActive &&
                                      test.hasAttempted != true,
                                )
                                .length;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstant.primaryColor,
                              AppConstant.primaryColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstant.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (state is SpecialTestsLoaded) {
                                final activeTests = state.tests.where(
                                  (test) => test.isActive && test.hasAttempted != true,
                                ).toList();
                                
                                if (activeTests.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              detail.SpecialTestDetailScreen(
                                                testId: activeTests.first.id,
                                                startImmediately: true,
                                              ),
                                    ),
                                  );
                                  return;
                                }
                              }
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const SpecialTestListScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.h,
                                    horizontal: 16.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Maxsus',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (testCount > 0)
                                  Positioned(
                                    right: 6.w,
                                    top: 6.h,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: testCount > 9 ? 6.w : 7.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.4),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        testCount > 9
                                            ? '9+'
                                            : testCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            BlocListener<SpecialTestBloc, SpecialTestState>(
              listener: (context, state) {
                if (state is SpecialTestError) {
                  // Silently handle error - don't show to user
                  // Special tests are optional feature
                }
              },
              child: const SizedBox(),
            ),
            BlocListener<SubjectAllBloc, SubjectAllState>(
              child: SizedBox(),
              listener: (context, state) async {
                if (state is SubjectAllErrorState) {
                  if (state.statusCode == 401) {
                    Logout(context);
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is SubjectAllSuccessState) {}
              },
            ),
            bodySection(),
          ],
        ),
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<SubjectAllBloc, SubjectAllState>(
      builder: (context, state) {
        if (state is SubjectAllSuccessState) {
          if (state.data.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: SizedBox(
                  height: 80.h,
                  child: Text(
                    "Fan mavjud emas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            );
          }
          List data = _filterSubjects(state.data);
          return Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                Subject subject = Subject(
                  id: data[index]["id"],
                  name: data[index]["name"].toString(),
                  imagePath: Endpoints.domain + data[index]["image"].toString(),
                );
                return SubjectCard(
                  subject: subject,
                  backgroundColor: Color(0xFFEAF8E5),
                  borderColor: Color(0xFF4CAF50),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BooksScreen(subject: subject),
                      ),
                    );
                  },
                );
              },
            ),
          );
        } else if (state is SubjectAllWaitingState) {
          return SizedBox(
            height: 300.h,
            child: CommonLoading(message: "Ma'lumot yuklanmoqda..."),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
