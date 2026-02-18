import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/section/section_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/section_card.dart';
import 'package:test_app/screens/test/random_test_screen.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  final bool stepBlock;
  final bool fullBlock;
  const BookScreen({super.key, 
    required this.book,
    this.fullBlock = false,
    this.stepBlock = true,
  });
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    super.initState();
    SectionController.getAll(context);
  }

  num getPercent(s) {
    var test = s["test"];
    int count = test?["_count"]?["test_items"] ?? 1;
    List results = test?["results"] ?? [];
    if (results.isEmpty) {
      return 0;
    }
    
    // Get the maximum score from all results
    num maxPercentage = 0;
    for (var result in results) {
      int solved = result["solved"] ?? 0;
      num percentage = (solved * 100.0) / count;
      if (percentage > maxPercentage) {
        maxPercentage = percentage;
      }
    }
    
    return maxPercentage.clamp(0, 100).roundToDouble();
  }

  bool hasTime() {
    Map? user = StorageService().read(StorageService.user);
    return user?["group"]?["hasTime"] ?? false;
  }

  // Check if all sections have passed with passing percentage
  bool allSectionsPassed(List data) {
    for (var section in data) {
      num percent = getPercent(section);
      if (percent < widget.book.passingPercentage) {
        return false;
      }
    }
    return true;
  }

  // Check if random test should be accessible
  Map<String, dynamic> checkRandomTestAccess(List data) {
    // If fullBlock is false and stepBlock is false, always allow
    if (!widget.fullBlock && !widget.stepBlock) {
      return {"allowed": true, "reason": ""};
    }

    // If stepBlock is true, check if all sections passed
    if (widget.stepBlock) {
      if (allSectionsPassed(data)) {
        return {"allowed": true, "reason": ""};
      } else {
        return {
          "allowed": false,
          "reason": "Tasodifiy testdan foydalanish uchun barcha bo'limlardan ${widget.book.passingPercentage}% dan yuqori natija olishingiz kerak"
        };
      }
    }

    return {"allowed": true, "reason": ""};
  }

  // Show blocked modal
  void showBlockedModal(BuildContext context, String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.lock_rounded,
                color: AppConstant.redColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Qulflangan",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            reason,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
              child: Text(
                "Tushunarli",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showRandomTestDialog(BuildContext context, List data) {
    int testCount = 20;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.shuffle_rounded,
                    color: AppConstant.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Tasodifiy Test",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Test savollar soni:",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: testCount.toDouble(),
                          min: 10,
                          max: 100,
                          divisions: 18,
                          label: testCount.toString(),
                          activeColor: AppConstant.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              testCount = value.toInt();
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstant.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "$testCount",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppConstant.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Bekor qilish",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    List<int> sectionIds = data
                        .map<int>((s) => s["id"] as int)
                        .toList();
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RandomTestScreen(
                          section: Section(
                            name: widget.book.name,
                            id: widget.book.id,
                            count: testCount,
                          ),
                          sections: sectionIds,
                          count: testCount,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                  ),
                  child: Text(
                    "Boshlash",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          titleText: widget.fullBlock 
            ? "${widget.book.name} 🔒" 
            : widget.book.name,
          isLeading: true,
        ),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : Colors.grey.shade50,
      body: widget.fullBlock
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Bu kitob qulflangan",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Ushbu kitobga admin tomonidan ruhsat berilmagan. Iltimos, admin bilan bog'laning.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                BlocListener<SectionAllBloc, SectionAllState>(
                  child: SizedBox(),
                  listener: (context, state) async {
                    if (state is SectionAllErrorState) {
                      if (state.statusCode == 401) {
                        Logout(context);
                      } else {
                        toastService.error(message: state.message ?? "Xatolik Bor");
                      }
                    } else if (state is SectionAllSuccessState) {}
                  },
                ),

                Expanded(child: bodySection()),
              ],
            ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<SectionAllBloc, SectionAllState>(
      builder: (context, state) {
        if (state is SectionAllSuccessState) {
          final data =
              state.data
                  .where(
                    (s) => s["book_id"].toString() == widget.book.id.toString(),
                  )
                  .toList()
                  .reversed
                  .toList();
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.layers_outlined,
                      size: 64.w,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Bo'limlar mavjud emas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Bu kitob uchun bo'limlar qo'shilmagan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: data.length + 1, // +1 for random test button
            itemBuilder: (context, index) {
              // First item - Random Test Button
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstant.primaryColor,
                          AppConstant.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstant.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Check if random test is accessible
                          Map<String, dynamic> accessCheck = checkRandomTestAccess(data);
                          if (accessCheck["allowed"]) {
                            showRandomTestDialog(context, data);
                          } else {
                            showBlockedModal(context, accessCheck["reason"]);
                          }
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            children: [
                              Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.shuffle_rounded,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tasodifiy Test",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Barcha bo'limlardan aralash",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Regular section cards
              int dataIndex = index - 1;
              Section section = Section(
                name: data[dataIndex]["name"],
                id: data[dataIndex]["id"],
                count: data[dataIndex]["test"]?["_count"]?["test_items"] ?? 0,
                percent: getPercent(data[dataIndex]),
                test_id: data[dataIndex]["test"]?["id"].toString(),
              );

              Section? prev;
              if (dataIndex != 0) {
                prev = Section(
                  name: data[dataIndex - 1]["name"],
                  id: data[dataIndex - 1]["id"],
                  count: data[dataIndex - 1]["test"]?["_count"]?["test_items"] ?? 0,
                  percent: getPercent(data[dataIndex - 1]),
                  test_id: data[dataIndex - 1]["test"]?["id"].toString(),
                );
              }

              bool isBlocked =
                  widget.fullBlock ||
                  (widget.stepBlock && dataIndex != 0 && (prev?.percent ?? 0) < widget.book.passingPercentage);

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SectionCard(
                  section: section,
                  block: isBlocked,
                  isFailed: widget.book.passingPercentage > section.percent,
                  passingPercentage: widget.book.passingPercentage,
                  onTap: () {
                    if (isBlocked) {
                      // Show message why it's blocked
                      toastService.error(
                        message: widget.fullBlock
                            ? "Bu kitob to'liq qulflangan"
                            : "Oldingi bo'limni kamida ${widget.book.passingPercentage}% natija bilan tugatishingiz kerak",
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectionScreen(section: section),
                      ),
                    );
                  },
                ),
              );
            },
          );
          // return Expanded(
          //   child: GridView.builder(
          //     padding: EdgeInsets.symmetric(vertical: 10.h),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.9,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 10,
          //     ),
          //     itemCount: state.data.length,
          //     itemBuilder: (context, index) {
          //       Result res = Result(
          //         solved: state.data[index]["solved"],
          //         date: DateTime.parse(state.data[index]["updatedAt"].toString()),
          //       );
          //       return   MyResultCard(section: sections[index],result: results[index], onTap: () {
          //        Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => SectionScreen(section: sections[index],),
          //                 ),
          //               );
          //     },
          //   );

          //     })
          // );
        } else if (state is SectionAllWaitingState) {
          return Center(
            child: CommonLoading(message: "Ma'lumot yuklanmoqda..."),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
