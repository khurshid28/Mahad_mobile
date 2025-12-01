// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/rate/rate_state.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/controller/rate_controller.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/book/books_body.dart';
import 'package:test_app/screens/home/home_screen.dart';
import 'package:test_app/screens/profile.dart';
import 'package:test_app/screens/saved/saved_body.dart';
import 'package:test_app/screens/special_test/special_test_detail_screen.dart';
import 'package:test_app/screens/test/test_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  List<String> appBarTitle = ['Asosiy', 'Kitoblar', 'Saqlanganlar', 'Profil'];
  List<Map<String, String>> svgIcon = [
    {
      'main': 'assets/icons/house.svg',
      'mainfill': 'assets/icons/housefill.svg',
    },
    {
      'contract': 'assets/icons/magazine.svg',
      'contractfill': 'assets/icons/magazinefill.svg',
    },
    {
      'heart': 'assets/icons/heart.svg',
      'heartfill': 'assets/icons/heartfill.svg',
    },
    {
      'profile': 'assets/icons/person.svg',
      'profilefill': 'assets/icons/personfill.svg',
    },
  ];

  ToastService toastService = ToastService();
  Map<String, dynamic>? incompleteTest;
  Timer? _bannerTimer;

  
  int findRate(List data){
    Map? user = StorageService().read(StorageService.user);
    int index = data.indexWhere((element)=> element["id"].toString() == "${user?["id"]}");
    return index == -1 ? 0 : index + 1;
  }
  num getPercent(List results){
     double score = 0;
     if(results.isEmpty) return 0;
     for (var r in results) {
       try {
         if (r["type"] == "RANDOM") {
           int solved = (r["solved"] ?? 0) as int;
           int totalItems = ((r["answers"] ?? []) as List).length;
           if (totalItems > 0) {
             score += solved / totalItems;
           }
         } else {
           int solved = (r["solved"] ?? 0) as int;
           int totalItems = r["test"]?["_count"]?["test_items"] ?? 1;
           if (totalItems > 0) {
             score += solved / totalItems;
           }
         }
       } catch (e) {
         print("Error calculating percent: $e");
       }
     }

     return (score * 1000/(results.length)).floor()/10;
  }
  List sortRates(List data){
    data.sort((a, b) => getPercent(b["results"]).compareTo(getPercent(a["results"])));
   return data;
  }
  @override
  void initState() { 
    super.initState();
    RateController.getAll(context);
    SectionController.getAll(context);
    
    // Timer to refresh incomplete test banner
    _bannerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        final test = getIncompleteTest();
        if (test != incompleteTest) {
          setState(() {
            incompleteTest = test;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  Map<String, dynamic>? getIncompleteTest() {
    final allKeys = StorageService().box.getKeys();

    // First check special tests
    for (var key in allKeys) {
      if (key.toString().startsWith('${StorageService.specialTest}-')) {
        final testData = StorageService().read(key);
        if (testData != null && testData is Map) {
          final finishTime = DateTime.tryParse(
            testData['finish_time']?.toString() ?? '',
          );
          if (finishTime != null) {
            if (finishTime.isBefore(DateTime.now())) {
              StorageService().remove(key.toString());
              continue;
            }
            final testId = key.toString().replaceFirst(
              '${StorageService.specialTest}-',
              '',
            );
            return {
              'testId': testId,
              'finishTime': finishTime,
              'data': testData,
              'type': 'special',
            };
          }
        }
      }
    }

    // Then check regular tests
    for (var key in allKeys) {
      if (key.toString().startsWith('${StorageService.test}-')) {
        final testData = StorageService().read(key);
        if (testData != null && testData is Map) {
          final finishTime = DateTime.tryParse(
            testData['finish_time']?.toString() ?? '',
          );
          if (finishTime != null) {
            if (finishTime.isBefore(DateTime.now())) {
              StorageService().remove(key.toString());
              continue;
            }
            final testId = key.toString().replaceFirst(
              '${StorageService.test}-',
              '',
            );
            return {
              'testId': testId,
              'finishTime': finishTime,
              'data': testData,
              'type': 'regular',
            };
          }
        }
      }
    }

    return null;
  }

  String _getRemainingTimeText(DateTime finishTime) {
    final remaining = finishTime.difference(DateTime.now());
    
    if (remaining.isNegative) {
      return 'Vaqt tugagan';
    }
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    if (hours > 0) {
      return 'Qolgan vaqt: ${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      return 'Qolgan vaqt: ${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
    return 'Qolgan vaqt: ${seconds} soniya';
  }

  void _continueTest(
    BuildContext context,
    Map<String, dynamic> testData,
  ) async {
    final testId = testData['testId'];
    final testType = testData['type'];

    if (testType == 'special') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => SpecialTestDetailScreen(
                testId: int.parse(testId),
                startImmediately: true,
              ),
        ),
      );
      return;
    }

    // Handle regular test
    final sectionsData = StorageService().read(StorageService.sections);
    if (sectionsData != null && sectionsData is List) {
      for (var section in sectionsData) {
        if (section['test_id'].toString() == testId) {
          final sectionModel = Section(
            id: section['id'],
            test_id: section['test_id'].toString(),
            name: section['name']?.toString(),
            count: section['count'] ?? 0,
            percent: section['percent'] ?? 0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestScreen(section: sectionModel),
            ),
          );
          return;
        }
      }
    }

    ToastService().error(message: 'Test topilmadi');
  }

  @override
  Widget build(BuildContext context) {
    // print("Access_token :"+ StorageService().read(StorageService.access_token));
    return Scaffold(
      key: scaffoldKey,
    
      backgroundColor: AppConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          titleText: appBarTitle[currentIndex],
          isLeading: false,

          actions: [
         BlocListener<RateBloc, RateState>(
              child: SizedBox(),
              listener: (context, state) async {
                if (state is RateErrorState) {
                  if (state.statusCode == 401) {
                    Logout(context);
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is RateSuccessState) {
                  sortRates(state.data);
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (incompleteTest != null)
            GestureDetector(
              onTap: () => _continueTest(context, incompleteTest!),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstant.primaryColor.withOpacity(0.9),
                      AppConstant.blueColor1,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstant.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tugallanmagan test',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _getRemainingTimeText(incompleteTest!['finishTime']),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Davom et',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppConstant.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(child: selectBody(currentIndex)),
        ],
      ),
      // drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      // drawerEnableOpenDragGesture: true,
      // drawerScrimColor: Colors.black38,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstant.whiteColor,
        selectedItemColor: AppConstant.primaryColor,
        unselectedItemColor: AppConstant.blackColor,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,

        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon:
                currentIndex != 0
                    ? SvgPicture.asset(svgIcon[0]['main'].toString())
                    : SvgPicture.asset(svgIcon[0]['mainfill'].toString()),
            label: 'Asosiy',
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 1
                    ? SvgPicture.asset(svgIcon[1]['contract'].toString())
                    : SvgPicture.asset(svgIcon[1]['contractfill'].toString()),
            label: 'Kitoblar',
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 2
                    ? SvgPicture.asset(svgIcon[2]['heart'].toString())
                    : SvgPicture.asset(svgIcon[2]['heartfill'].toString()),
            label: "Saqlanganlar",
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 3
                    ? SvgPicture.asset(svgIcon[3]['profile'].toString())
                    : SvgPicture.asset(svgIcon[3]['profilefill'].toString()),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  selectBody<Widget>(int currentIndex) {
    if (currentIndex == 0) {
      return HomeScreen();
    } else if (currentIndex == 1) {
      return BooksBody();
    } else if (currentIndex == 2) {
      return SavedBody();
    } else if (currentIndex == 3) {
      return const ProfileScreen();
    }
    return HomeScreen();

    // if (currentIndex == 0) {
    //   return const HomeScreen();
    // } else if (currentIndex == 1) {
    //   return const DocumentScreen();
    // } else if (currentIndex == 2) {
    //   return const MarketScreen();
    // } else if (currentIndex == 3) {
    //   return const ProfileScreen();
    // }
  }
}
