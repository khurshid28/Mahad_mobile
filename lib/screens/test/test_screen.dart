import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/result/result_post_state.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
import 'package:test_app/blocs/test/test_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/controller/test_controller.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finish_screen.dart';
import 'package:test_app/service/loading_Service.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';

class TestScreen extends StatefulWidget {
  final Section section;
  TestScreen({required this.section});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map getAnswers(int count) {
    var res = StorageService().read(
      "${StorageService.result}-${widget.section.test_id}",
    );
    if (res == null) {
      var new_res = {};
      List.generate(count, (index) => index + 1).forEach((e) {
        new_res[e.toString()] = "";
      });
      return new_res;
    }
    return res;
  }

  Future clearAnswers() async {
    await StorageService().remove(
      "${StorageService.result}-${widget.section.test_id}",
    );
  }

  Future writeAnswer(
    int count, {
    required int index,
    required String result,
  }) async {
    var res = getAnswers(count);
    res["${index + 1}"] = result;

    await StorageService().write(
      "${StorageService.result}-${widget.section.test_id}",
      res,
    );
  }

  int item_index = 0;

  int rightAnswer(List items) {
    var res = getAnswers(items.length);
    int count = 0;
    for (var element in items) {
      if (element["answer"] == res["${element['number']}"]) {
        count++;
      }
    }
    return count;
  }

  @override
  void initState() {
    super.initState();
    TestController.getByid(context, id: widget.section.test_id ?? 0);
  }

  LoadingService loadingService = LoadingService();
  ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppConstant.whiteColor,
        title: Text(
          "Angliya XII asr",
          style: TextStyle(
            color: AppConstant.blackColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/close.svg',
            width: 18.w,
            colorFilter: const ColorFilter.mode(
              AppConstant.blackColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: BlocListener<TestBloc, TestState>(
        child: bodySection(),
        listener: (context, state) async {
          if (state is TestErrorState) {
            if (state.statusCode == 401) {
              Logout(context);
            } else {
              toastService.error(message: state.message ?? "Xatolik Bor");
            }
          } else if (state is TestSuccessState) {}
        },
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        if (state is TestSuccessState) {
          List test_items = state.data["test_items"] ?? [];
          var test = test_items[item_index];
          var count = test_items.length;
          var results = getAnswers(count);

          String? answer = results["${item_index + 1}"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 1.sw - 64,
                        child: Text(
                          "${test['number']}.${test['question']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),

                      ...List.generate(
                        4,
                        (index) => GestureDetector(
                          onTap: () async {
                            await writeAnswer(
                              count,
                              index: item_index,
                              result: ["A", "B", "C", "D"][index],
                            );
                            setState(() {
                              answer = ["A", "B", "C", "D"][index];
                            });
                          },
                          child: Container(
                            width: 1.sw - 32,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                children: [
                                  ["A", "B", "C", "D"][index] == answer
                                      ? Container(
                                        width: 34.w,
                                        height: 34.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          color: AppConstant.primaryColor,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/check.svg',
                                          width: 18.w,
                                          colorFilter: const ColorFilter.mode(
                                            AppConstant.whiteColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      )
                                      : Container(
                                        width: 34.w,
                                        height: 34.w,

                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade500,
                                            width: 3.w,
                                          ),
                                        ),
                                        child: Text(
                                          [
                                            "A",
                                            "B",
                                            "C",
                                            "D",
                                          ][index].toString(),
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    width: 305.w,
                                    child: Text(
                                      test["answer_${["A", "B", "C", "D"][index]}"]
                                          .toString(),
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              BlocListener<ResultPostBloc, ResultPostState>(
                child: SizedBox(),
                listener: (context, state) async {
                  if (state is ResultPostWaitingState) {
                    loadingService.showLoading(context);
                  } else if (state is ResultPostErrorState) {
                    loadingService.closeLoading(context);
                    if (state.statusCode ==401) {
                      Logout(context);
                    }else{
                       toastService.error(message: state.message ?? "Xatolik Bor");
                    }
                    
                   
                  } else if (state is ResultPostSuccessState) {
                    loadingService.closeLoading(context);

                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FinishTestScreen(
                              count: count,
                              right: rightAnswer(test_items),
                            ),
                      ),
                    );
                    clearAnswers();
                  }
                },
              ),

              SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          if (item_index == count - 1) {
                            await ResultController.post(
                              context,
                              solved:  rightAnswer(test_items),
                              test_id: widget.section.test_id ?? 0,
                            );
                          } else if (item_index < count - 1) {
                            setState(() {
                              answer = "";
                              item_index++;
                            });
                          }
                         
                        },
                        child: Center(
                          child: Text(
                            item_index == count - 1
                                ? "Tugatish"
                                : "Davom qilish",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (item_index > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: () {
                            if (item_index > 0) {
                              setState(() {
                                answer = "";
                                item_index--;
                              });
                            }
                            // Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "Orqaga qaytish",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          );
        } else if (state is TestWaitingState) {
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
