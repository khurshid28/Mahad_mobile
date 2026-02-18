import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_bloc.dart';
import 'package:test_app/blocs/section/section_state.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finished_test_screen.dart';
import 'package:test_app/screens/test/test_screen.dart';
import 'package:test_app/screens/test/test_screen_notime.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/result_card.dart';

class SectionScreen extends StatefulWidget {
  final Section section;
  const SectionScreen({super.key, required this.section});
  @override
  _SectionScreenState createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  @override
  void initState() {
    super.initState();
    SectionController.getByid(context, id: widget.section.id ?? 0);
  }

  ToastService toastService = ToastService();
  Map? getAnswers() {
    return StorageService().read(
      "${StorageService.result}-${widget.section.test_id}",
    );
  }

  getSection() {
    var sections = StorageService().read(StorageService.sections) ?? {};
    var section = sections["${widget.section.id}"];
    return section;
  }

  Future likeSection(Map sectionData) async {
    String key = "${widget.section.id}";
    Map sections = StorageService().read(StorageService.sections) ?? {};

    var section = sections["${widget.section.id}"];
    if (section != null) {
      sections.remove(key);
    } else {
      sections[key] = sectionData;
    }
    await StorageService().write(StorageService.sections, sections);
  }

  Future clearAnswers() async {
    await Future.wait([
      StorageService().remove(
        "${StorageService.result}-${widget.section.test_id}",
      ),
      StorageService().remove(
        "${StorageService.test}-${widget.section.test_id}",
      ),
    ]);
  }

  bool hasTime() {
    Map? user = StorageService().read(StorageService.user);
    return user?["group"]?["hasTime"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          titleText: widget.section.name ?? "",
          isLeading: true,
        ),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<SectionBloc, SectionState>(
              child: SizedBox(),
              listener: (context, state) async {
                if (state is SectionErrorState) {
                  if (state.statusCode == 401) {
                    Logout(context);
                  } else if (state.statusCode == 403) {
                    // Forbidden - access denied (e.g., previous section not passed)
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Ruxsat berilmadi",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        content: Text(
                          state.message ?? "Bu bo'limga kirish uchun oldingi bo'limni tugatishingiz kerak",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              Navigator.of(context).pop(); // Go back to previous screen
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is SectionSuccessState) {
                  // Check if section is blocked
                  final isBlocked = state.data["isBlocked"] ?? false;
                  final blockReason = state.data["blockReason"] ?? "";
                  
                  if (isBlocked == true && blockReason.isNotEmpty) {
                    // Show modal and go back
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: AppConstant.redColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Ruxsat berilmadi",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          blockReason,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Close dialog
                              Navigator.of(context).pop(); // Go back to previous screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstant.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
            resultSection(),
          ],
        ),
      ),
    );
  }

  Widget resultSection() {
    return BlocBuilder<SectionBloc, SectionState>(
      builder: (context, state) {
        if (state is SectionSuccessState) {
          List results = state.data["test"]?["results"] ?? [];
          var answers = getAnswers();
          var storageSection = getSection();
          print("++++++");
          print(storageSection);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppConstant.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 48.sp,
                      color: AppConstant.primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.section.name ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Jami: ${widget.section.count} ta",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () async {
                        await likeSection(state.data);
                        setState(() {});
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color:
                              storageSection != null
                                  ? AppConstant.redColor.withOpacity(0.1)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Icon(
                            storageSection != null
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                storageSection != null
                                    ? AppConstant.redColor
                                    : Colors.grey.shade400,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (answers != null)
                      ResultCard(
                        result: Result(
                          date: DateTime.now(),
                          solved: 0,
                          test: state.data["test"],
                          finished: false,
                        ),
                        count: widget.section.count,
                        onTap: () {},
                      ),
                    ...List.generate(results.length, (index) {
                      Result res = Result(
                        date: DateTime.parse(
                          results[index]["createdt"].toString(),
                        ),
                        solved: results[index]["solved"],
                        test: state.data["test"],
                      );

                      return ResultCard(
                        result: res,
                        count: widget.section.count,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FinishedTestScreen(
                                    section: Section(
                                      name: state.data["name"].toString(),
                                      count: results.length,
                                      test_id:
                                          state.data["test"]?["id"]?.toString(),
                                    ),
                                    answers: results[index]["answers"],
                                  ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              if (widget.section.count > 0)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppConstant.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstant.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      hasTime()
                                          ? TestScreen(
                                            section: Section(
                                              name:
                                                  state.data["name"].toString(),
                                              count: widget.section.count,
                                              test_id:
                                                  (state.data["test"]?["id"] ??
                                                          0)
                                                      .toString(),
                                            ),
                                          )
                                          : TestScreenNotime(
                                            section: Section(
                                              name:
                                                  state.data["name"].toString(),
                                              count: widget.section.count,
                                              test_id:
                                                  (state.data["test"]?["id"] ??
                                                          0)
                                                      .toString(),
                                            ),
                                          ),
                            ),
                          );
                          setState(() {
                            answers = getAnswers();
                          });
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                answers != null
                                    ? Icons.play_arrow_rounded
                                    : Icons.assignment_outlined,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                answers != null
                                    ? "Davom qilish"
                                    : "Testni boshlash",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (answers != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppConstant.primaryColor,
                        width: 1.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await clearAnswers();
                          setState(() {
                            answers = null;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      hasTime()
                                          ? TestScreen(
                                            section: Section(
                                              name:
                                                  state.data["name"].toString(),
                                              count: widget.section.count,
                                              test_id:
                                                  (state.data["test"]?["id"] ??
                                                          0)
                                                      .toString(),
                                            ),
                                          )
                                          : TestScreenNotime(
                                            section: Section(
                                              name:
                                                  state.data["name"].toString(),
                                              count: widget.section.count,
                                              test_id:
                                                  (state.data["test"]?["id"] ??
                                                          0)
                                                      .toString(),
                                            ),
                                          ),
                            ),
                          );
                          setState(() {
                            answers = getAnswers();
                          });
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: AppConstant.primaryColor,
                                size: 24.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Yangidan boshlash",
                                style: TextStyle(
                                  color: AppConstant.primaryColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else if (state is SectionWaitingState) {
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
