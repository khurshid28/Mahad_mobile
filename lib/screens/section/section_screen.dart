import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_bloc.dart';
import 'package:test_app/blocs/section/section_state.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finished_test_screen.dart';
import 'package:test_app/screens/test/test_screen.dart';
import 'package:test_app/screens/test/test_screen_notime.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/result_card.dart';
import 'package:test_app/widgets/section_card.dart';

class SectionScreen extends StatefulWidget {
  final Section section;
  SectionScreen({required this.section});
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

  Future likeSection(Map section_data) async {
    String key = "${widget.section.id}";
    Map sections = StorageService().read(StorageService.sections) ?? {};

    var section = sections["${widget.section.id}"];
    if (section != null) {
      sections.remove(key);
    } else {
      sections[key] = section_data;
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
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is SectionSuccessState) {}
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
                height: 320.h,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/magazinefill.svg",
                  width: 80.w,
                  height: 80.h,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child:
                              storageSection != null
                                  ? SvgPicture.asset(
                                    "assets/icons/heartfill.svg",
                                    width: 35.w,
                                    height: 35.h,
                                    color: AppConstant.redColor,
                                  )
                                  : SvgPicture.asset(
                                    "assets/icons/heart.svg",
                                    width: 35.w,
                                    height: 35.h,
                                    color: Colors.grey.shade400,
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
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  hasTime()
                                      ? TestScreen(
                                        section: Section(
                                          name: state.data["name"].toString(),
                                          count: results.length,
                                          test_id:
                                              (state.data["test"]?["id"] ?? 0)
                                                  .toString(),
                                        ),
                                      )
                                      : TestScreenNotime(
                                        section: Section(
                                          name: state.data["name"].toString(),
                                          count: results.length,
                                          test_id:
                                              (state.data["test"]?["id"] ?? 0)
                                                  .toString(),
                                        ),
                                      ),
                        ),
                      );
                      setState(() {
                        answers = getAnswers();
                      });
                    },
                    child: Center(
                      child: Text(
                        answers != null ? "Davom qilish" : "Testni boshlash",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),

              if (answers != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () async {
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
                                          name: state.data["name"].toString(),
                                          count: results.length,
                                          test_id:
                                              (state.data["test"]?["id"] ?? 0)
                                                  .toString(),
                                        ),
                                      )
                                      : TestScreenNotime(
                                        section: Section(
                                          name: state.data["name"].toString(),
                                          count: results.length,
                                          test_id:
                                              (state.data["test"]?["id"] ?? 0)
                                                  .toString(),
                                        ),
                                      ),
                        ),
                      );
                      setState(() {
                        answers = getAnswers();
                      });
                    },
                    child: Center(
                      child: Text(
                        "Yangidan boshlash",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else if (state is SectionWaitingState) {
          return SizedBox(
            height: 300.h,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppConstant.primaryColor,
                    strokeWidth: 6.w,
                    strokeAlign: 2,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppConstant.primaryColor.withOpacity(0.2),
                  ),
                  SizedBox(height: 48.h),
                  SizedBox(
                    height: 30.h,
                    child: Text(
                      "Ma\'lumot yuklanmoqda...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
