import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/result/result_post_state.dart';
import 'package:test_app/blocs/test/random_test_bloc.dart';
import 'package:test_app/blocs/test/random_test_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/controller/test_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finish_screen.dart';
import 'package:test_app/service/loading_Service.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';

import 'dart:math' as math;

class RandomTestScreen extends StatefulWidget {
  final Section section;
  List<int> sections;
  int count;
  final int? customFullTime; // Student tanlagan umumiy vaqt (minutlarda)
  final int?
  customTimePerQuestion; // Student tanlagan har bir savol uchun vaqt (minutlarda)
  final bool? useTimer; // Timer ishlatilsinmi
  final bool? forceNextQuestion; // Keyingi savolga o'tish majburiy

  RandomTestScreen({
    super.key,
    required this.section,
    required this.sections,
    required this.count,
    this.customFullTime,
    this.customTimePerQuestion,
    this.useTimer,
    this.forceNextQuestion,
  });

  @override
  _RandomTestScreenState createState() => _RandomTestScreenState();
}

class _RandomTestScreenState extends State<RandomTestScreen> {
  Map getAnswers(int count) {
    String resKey = "${StorageService.result}-$test_random_id";
    var res = StorageService().read("${StorageService.result}-$test_random_id");
    if (res == null) {
      var newRes = {};
      for (var e in List.generate(count, (index) => index + 1)) {
        newRes[e.toString()] = "";
      }
      return newRes;
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
    String resKey = "${StorageService.result}-$test_random_id";
    var res = getAnswers(count);
    res["${index + 1}"] = result;

    await StorageService().write(resKey, res);
  }

  int item_index = 0;
  int test_random_id = 0;

  // Load current question index from storage
  void loadCurrentIndex() {
    var test = StorageService().read("${StorageService.test}-$test_random_id");
    if (test != null && test['current_index'] != null) {
      setState(() {
        item_index = test['current_index'];
      });
    }
  }

  // Save current question index to storage
  void saveCurrentIndex() {
    var test = StorageService().read("${StorageService.test}-$test_random_id");
    if (test != null) {
      test['current_index'] = item_index;
      StorageService().write("${StorageService.test}-$test_random_id", test);
    }
  }

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

  Map? getTestsFromStorage(List items) {
    String testKey = "${StorageService.test}-$test_random_id";
    var test = StorageService().read(testKey);
    print(testKey);
    if (test == null) {
      var resItems = [];
      math.Random random = math.Random();

      items.shuffle(random);
      var len = items.length;

      for (var i = 0; i < len; i++) {
        var item = items[i];
        var rightIndex = random.nextInt(4);
        var answers = ["A", "B", "C", "D"];
        var answersRandom = ["A", "B", "C", "D"];

        var rightAnswer = answers[rightIndex];
        answersRandom.removeAt(rightIndex);
        answers.removeAt(rightIndex);

        var ans = item["answer"] ?? "";
        var ansText = item["answer_" + ans];
        var extraItem = {};
        extraItem["answer_$rightAnswer"] = ansText;
        //change value
        var extra = item["answer_" + ans];
        item["answer_" + ans] = item["answer_$rightAnswer"];
        item["answer_$rightAnswer"] = extra;

        answersRandom.shuffle(random);
        // print("shuffle");
        // print(item["answer"]);
        // print("Random answer : " + rightAnswer);
        // print(answersRandom);

        //  print(" Right : extraItem[${'answer_' + rightAnswer}] = item[${'answer_' + item["answer"]}]");

        for (var j = 0; j < answers.length; j++) {
          //  print("extraItem[${'answer_' + answersRandom[j]}] = item[${'answer_' + answers[j]}]");
          extraItem["answer_${answersRandom[j]}"] =
              item["answer_${answers[j]}"];
        }

        resItems.add({
          "number": i + 1,

          "question": item["question"] ?? "",
          "answer_A": extraItem["answer_A"],
          "answer_B": extraItem["answer_B"],
          "answer_C": extraItem["answer_C"],
          "answer_D": extraItem["answer_D"],
          "answer": rightAnswer,
          "createdt": item["createdt"],
          "updatedAt": item["updatedAt"],
          "test_id": item["test_id"],
        });

        //
      }

      var now = DateTime.now();
      int finishTime = getFinishTime(len); // in seconds

      // for (var i = 0; i < 20; i++) {
      //   print(getFinishTime(100));
      // }

      Map? data = {
        "time": now.toString(),
        "finish_time": now.add(Duration(seconds: finishTime)).toString(),
        "data": resItems,
        "current_index": 0,
      };

      StorageService().write(testKey, data);
      return data;
    }
    return test;
  }

  int remainingTime = 0;
  List test_items = [];
  Timer? timer;
  Timer? perQuestionTimer;
  int perQuestionRemainingTime = 0;

  bool isPerQuestionTime() {
    // Agar student o'zi parametr bergan bo'lsa
    if (widget.customFullTime != null || widget.customTimePerQuestion != null) {
      return widget.customFullTime == null &&
          widget.customTimePerQuestion != null;
    }

    // Aks holda guruh parametrlaridan foydalanish
    Map? user = StorageService().read(StorageService.user);
    int fullTime = user?["group"]?["fullTime"] ?? 0;
    int timeMinutes = user?["group"]?["timeMinutes"] ?? 0;
    return fullTime == 0 && timeMinutes > 0;
  }

  getFinishTime(int count) {
    // Agar student timer ishlatmaslikni tanlagan bo'lsa
    if (widget.useTimer == false) {
      return 0;
    }

    // Agar student o'zi parametr bergan bo'lsa
    if (widget.customFullTime != null) {
      return widget.customFullTime! * 60; // minutdan sekundga
    }
    if (widget.customTimePerQuestion != null) {
      return widget.customTimePerQuestion! * count; // sekundda
    }

    // Aks holda guruh parametrlaridan foydalanish
    Map? user = StorageService().read(StorageService.user);
    bool hasTime = user?["group"]?["hasTime"] ?? false;

    if (!hasTime) {
      return 0; // Timer yo'q
    }

    int fullTime = user?["group"]?["fullTime"] ?? 0;
    int timeMinutes = user?["group"]?["timeMinutes"] ?? 0;

    // fullTime > 0 bo'lsa, umumiy vaqt (minutlarda)
    if (fullTime > 0) {
      return fullTime * 60; // sekundlarga o'zgartirish
    }
    // fullTime == 0 bo'lsa, har bir savol uchun timeMinutes
    else if (timeMinutes > 0) {
      return timeMinutes * count * 60; // sekundlarga o'zgartirish
    }

    return 0;
  }

  Future<void> _finishTest() async {
    var count = test_items.length;
    var results = getAnswers(count);

    await ResultController.post(
      context,
      solved: rightAnswer(test_items),
      test_id: int.tryParse(widget.section.test_id.toString()) ?? 0,
      answers:
          test_items
              .map(
                (e) => {
                  ...(e as Map),
                  "my_answer": results[e["number"].toString()],
                },
              )
              .toList(),
      type: "RANDOM",
    );
  }

  @override
  void initState() {
    test_random_id = math.Random().nextInt(100000);
    print("INITTTTTTTTTTTTTTTTTTTTTTTTT >>");
    super.initState();
    TestController.getRandom(
      context,
      count: widget.count,
      sections: widget.sections,
    );

    // Load current question index from storage
    Future.delayed(Duration(milliseconds: 100), () {
      loadCurrentIndex();

      // Initialize remainingTime from storage
      var test = getTestsFromStorage(test_items);
      if (test != null && test["finish_time"] != null) {
        var finish = DateTime.parse(test["finish_time"]);
        var now = DateTime.now();
        remainingTime = finish.difference(now).inSeconds;
        if (remainingTime < 0) remainingTime = 0;
      }

      // Guruh yoki student timer parametrlarini tekshirish
      Map? user = StorageService().read(StorageService.user);
      bool hasTime = widget.useTimer ?? (user?["group"]?["hasTime"] ?? false);

      if (!hasTime) {
        // Timer yo'q, hech narsa qilmaslik
        return;
      }

      // Har bir savol uchun vaqt bo'lsa
      if (isPerQuestionTime()) {
        int timeValue =
            widget.customTimePerQuestion ??
            (user?["group"]?["timeMinutes"] ?? 0);
        // Agar customTimePerQuestion bo'lsa, u allaqachon sekundda
        // Aks holda timeMinutes minutda, sekundga o'zgartirish kerak
        perQuestionRemainingTime =
            widget.customTimePerQuestion != null ? timeValue : (timeValue * 60);

        perQuestionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            if (perQuestionRemainingTime <= 0) {
              // Vaqt tugadi, guruhda forceNextQuestion tekshirish
              Map? user = StorageService().read(StorageService.user);
              bool forceNextQuestion =
                  user?["group"]?["forceNextQuestion"] ?? false;

              if (forceNextQuestion) {
                // Majburiy keyingi savolga o'tish
                var count = test_items.length;
                if (item_index < count - 1) {
                  setState(() {
                    item_index++;
                    saveCurrentIndex();
                    int timeValue =
                        widget.customTimePerQuestion ??
                        (user?["group"]?["timeMinutes"] ?? 0);
                    perQuestionRemainingTime =
                        widget.customTimePerQuestion != null
                            ? timeValue
                            : (timeValue * 60);
                  });
                } else {
                  // Oxirgi savol, testni tugatish
                  timer.cancel();
                  _finishTest();
                }
              }
            } else {
              perQuestionRemainingTime--;
              setState(() {});
            }
          }
        });
      } else {
        // Umumiy vaqt uchun timer
        if (remainingTime > 0) {
          timer = Timer.periodic(Duration(seconds: 1), (timer) {
            if (mounted) {
              if (remainingTime <= 0) {
                timer.cancel();
                _finishTest();
              } else {
                remainingTime--;
                setState(() {});
              }
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    perQuestionTimer?.cancel();
  }

  String realText(String data) {
    List<String> d = data.split(".");
    if (d.length > 1 && int.tryParse(d[0].toString()) != null) {
      return d[1];
    }

    List<String> b = data.split(" ");
    if (b.length > 1 && int.tryParse(b[0].toString()) != null) {
      return b[1];
    }
    return data;
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
          widget.section.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppConstant.blackColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: Center(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppConstant.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: AppConstant.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : Colors.grey.shade200,
      body: BlocListener<RandomTestBloc, RandomTestState>(
        child: bodySection(),
        listener: (context, state) async {
          if (state is RandomTestErrorState) {
            if (state.statusCode == 401) {
              Logout(context);
            } else {
              toastService.error(message: state.message ?? "Xatolik Bor");
            }
          } else if (state is RandomTestSuccessState) {
            // await StorageService().remove(
            //   "${StorageService.test}-${widget.section.test_id}",
            // );
          }
        },
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<RandomTestBloc, RandomTestState>(
      builder: (context, state) {
        if (state is RandomTestSuccessState) {
          Map? storageData = getTestsFromStorage(state.data ?? []);
          test_items = storageData?["data"] ?? [];
          var test = test_items[item_index];
          var count = test_items.length;
          test_items = storageData?["data"] ?? [];

          var results = getAnswers(count);
          remainingTime =
              (DateTime.tryParse(
                        (storageData?["finish_time"] ?? "").toString(),
                      ) ??
                      DateTime.now())
                  .difference(DateTime.now())
                  .inSeconds;
          // print(">>>>" + remainingTime.toString());
          // print(storage_data?["finish_time"] ?? "");
          int minutes = remainingTime ~/ 60;
          int seconds = remainingTime % 60;
          // for (var i = 0; i < 20; i++) {
          //   print("TIME >>");
          //   print(storage_data?["time"]);
          //   print(storage_data?["finish_time"]);
          // }
          print(
            "Tugash vaqti: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
          );

          String? answer = results["${item_index + 1}"];
          return SingleChildScrollView(
            child: Column(
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
                          child: Row(
                            children: [
                              Text(
                                isPerQuestionTime()
                                    ? "Savol vaqti: ${perQuestionRemainingTime}s"
                                    : (remainingTime >= 0
                                        ? "Tugash vaqti:  ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"
                                        : "Tugash vaqti:  00:00"),
                                style: TextStyle(
                                  color:
                                      (isPerQuestionTime()
                                                  ? perQuestionRemainingTime
                                                  : remainingTime) >
                                              0
                                          ? AppConstant.blueColor1
                                          : AppConstant.redColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                "[${item_index + 1}/$count]",
                                style: TextStyle(
                                  color: AppConstant.primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: 1.sw - 64,
                          child: Text(
                            "${test['number']}.${realText(test['question'].toString())}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),

                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  print(test["answer"]);
                                  if ((answer?.isEmpty ?? true)) {
                                    await writeAnswer(
                                      count,
                                      index: item_index,
                                      result: ["A", "B", "C", "D"][index],
                                    );
                                    setState(() {
                                      answer = ["A", "B", "C", "D"][index];
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  width: 1.sw - 32.w,
                                  decoration: BoxDecoration(
                                    color:
                                        (answer?.isNotEmpty ?? false) &&
                                                ["A", "B", "C", "D"][index] ==
                                                    test["answer"]
                                            ? AppConstant.primaryColor
                                                .withOpacity(0.1)
                                            : answer ==
                                                ["A", "B", "C", "D"][index]
                                            ? AppConstant.redColor.withOpacity(
                                              0.1,
                                            )
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color:
                                          (answer?.isNotEmpty ?? false) &&
                                                  ["A", "B", "C", "D"][index] ==
                                                      test["answer"]
                                              ? AppConstant.primaryColor
                                              : answer ==
                                                  ["A", "B", "C", "D"][index]
                                              ? AppConstant.redColor
                                              : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Row(
                                      children: [
                                        ((answer?.isNotEmpty ?? false) &&
                                                ["A", "B", "C", "D"][index] ==
                                                    test["answer"])
                                            ? Container(
                                              width: 34.w,
                                              height: 34.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                color: AppConstant.primaryColor,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/check.svg',
                                                width: 18.w,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      AppConstant.whiteColor,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                            )
                                            : answer ==
                                                ["A", "B", "C", "D"][index]
                                            ? Container(
                                              width: 34.w,
                                              height: 34.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                color: AppConstant.redColor,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/close.svg',
                                                width: 18.w,
                                                colorFilter:
                                                    const ColorFilter.mode(
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
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
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

                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            test["answer_${["A", "B", "C", "D"][index]}"]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      if (state.statusCode == 401) {
                        Logout(context);
                      } else {
                        toastService.error(
                          message: state.message ?? "Xatolik Bor",
                        );
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
                      if (!isPerQuestionTime())
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
                                  color: AppConstant.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (item_index == count - 1) {
                                    await _finishTest();
                                  } else if (item_index < count - 1) {
                                    setState(() {
                                      answer = "";
                                      item_index++;
                                      saveCurrentIndex();
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(12.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        item_index == count - 1
                                            ? Icons.check_circle_outline
                                            : Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        item_index == count - 1
                                            ? "Tugatish"
                                            : "Davom qilish",
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

                      // Har bir savol uchun vaqt bo'lsa va forceNextQuestion false bo'lsa tugmani ko'rsatamiz
                      if (isPerQuestionTime() &&
                          !(widget.forceNextQuestion ??
                              StorageService().read(
                                StorageService.user,
                              )?["group"]?["forceNextQuestion"] ??
                              false))
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
                                  color: AppConstant.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (item_index == count - 1) {
                                    await _finishTest();
                                  } else if (item_index < count - 1) {
                                    setState(() {
                                      answer = "";
                                      item_index++;
                                      saveCurrentIndex();
                                      // Reset timer for next question
                                      Map? user = StorageService().read(
                                        StorageService.user,
                                      );
                                      int timeValue =
                                          widget.customTimePerQuestion ??
                                          (user?["group"]?["timeMinutes"] ?? 0);
                                      perQuestionRemainingTime =
                                          widget.customTimePerQuestion != null
                                              ? timeValue
                                              : (timeValue * 60);
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(12.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        item_index == count - 1
                                            ? Icons.check_circle_outline
                                            : Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        item_index == count - 1
                                            ? "Tugatish"
                                            : "Keyingi savol",
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

                      if (item_index > 0 &&
                          !isPerQuestionTime() &&
                          !(widget.forceNextQuestion ?? false))
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
                                onTap: () {
                                  if (item_index > 0) {
                                    setState(() {
                                      answer = "";
                                      item_index--;
                                      saveCurrentIndex();
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(16.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: AppConstant.primaryColor,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Orqaga qaytish",
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
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is RandomTestWaitingState) {
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
