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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:test_app/blocs/special_test/special_test_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/controller/subject_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/books_screen.dart';
import 'package:test_app/screens/special_test/special_test_list_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/subject_card.dart';

class HomeScreen extends StatefulWidget {
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



  @override
  void initState() {
    super.initState();
    checkForUpdate();
    SubjectController.getAll(context);
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
    return  subjects
              .where(
                (subject) =>
                    subject["name"].toLowerCase().contains(seachController.text.toLowerCase()),
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
      floatingActionButton: BlocBuilder<SpecialTestBloc, SpecialTestState>(
        builder: (context, state) {
          int testCount = 0;
          if (state is SpecialTestsLoaded) {
            // Faqat aktiv va yechilmagan testlarni sanash
            testCount = state.tests.where((test) => test.isActive && test.hasAttempted != true).length;
          }
          
          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpecialTestListScreen(),
                    ),
                  );
                },
                backgroundColor: AppConstant.primaryColor,
                icon: const Icon(Icons.star, color: Colors.white),
                label: const Text(
                  'Maxsus Testlar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (testCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: testCount > 99 ? 6.w : 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstant.accentOrange,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstant.accentOrange.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      testCount > 99 ? '99+' : testCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: AppConstant.primaryColor,
              // onChanged: _filterSubjects,
              onChanged: (value) => setState(() {}),
    controller: seachController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 15.h,
                ),
                fillColor: isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade200,
                filled: true,

                hintText: "Fan qidirish",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 17.w,
                    right: 8.w,
                    top: 10.w,
                    bottom: 10.w,
                  ),

                  child: SvgPicture.asset(
                    "assets/icons/search.svg",
                    width: 10.w,
                    height: 10.h,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
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
                  imagePath:
                      Endpoints.domain + data[index]["image"].toString(),
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
            child: CommonLoading(
              message: "Ma'lumot yuklanmoqda...",
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
