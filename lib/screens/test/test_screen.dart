import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/result/result_post_state.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
import 'package:test_app/blocs/test/test_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/controller/test_controller.dart';
import 'package:test_app/controller/student_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finish_screen.dart';
import 'package:test_app/service/loading_Service.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:screen_protector/screen_protector.dart';
import 'package:vibration/vibration.dart';

import 'dart:math' as math;

class TestScreen extends StatefulWidget {
  final Section section;
  const TestScreen({super.key, required this.section});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    print('🔵 [test_screen] initState() boshlandi - test_id: ${widget.section.test_id}');
    _disableScreenshot();
    loadCurrentIndex();
    print('🔵 [test_screen] _loadGroupData() chaqirish oldidan...');
    _loadGroupData();
    print('🔵 [test_screen] TestController.getByid() chaqirilmoqda...');
    TestController.getByid(
      context,
      id: int.tryParse(widget.section.test_id.toString()) ?? 0,
    );
  }

  @override
  void dispose() {
    _enableScreenshot();
    timer?.cancel();
    perQuestionTimer?.cancel();
    super.dispose();
  }

  Future<void> _disableScreenshot() async {
    if (!kIsWeb) {
      try {
        await ScreenProtector.protectDataLeakageOn();
      } catch (e) {
        print('Screenshot bloklashda xato: $e');
      }
    }
  }

  Future<void> _enableScreenshot() async {
    if (!kIsWeb) {
      try {
        await ScreenProtector.protectDataLeakageOff();
      } catch (e) {
        print('Screenshot yoqishda xato: $e');
      }
    }
  }

  bool _isSpecialAnswer(String? answer) {
    if (answer == null || answer.isEmpty) return false;
    
    String normalized = answer.toLowerCase().trim();
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    String withoutApostrophes = normalized.replaceAll(RegExp(r"['`′´ʹʻ]"), "");
    
    final specialPatterns = [
      "togri javob yoq",
      "to'g'ri javob yo'q",
      "toʻgʻri javob yoʻq",
      "barcha javoblar togri",
      "barcha javoblar to'g'ri",
      "barcha javoblar toʻgʻri",
      "hammasi togri",
      "hammasi to'g'ri",
      "togri javob berilmagan",
      "to'g'ri javob berilmagan",
      "toʻgʻri javob berilmagan",
    ];
    
    for (var pattern in specialPatterns) {
      if (normalized.contains(pattern)) return true;
      String patternWithoutApostrophes = pattern.replaceAll(RegExp(r"['`′´ʹʻ]"), "");
      if (withoutApostrophes.contains(patternWithoutApostrophes)) return true;
    }
    
    return false;
  }

  Map getAnswers(int count) {
    var res = StorageService().read(
      "${StorageService.result}-${widget.section.test_id}",
    );
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
    await StorageService().remove(
      "${StorageService.test}-${widget.section.test_id}",
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

  // Load current question index from storage
  void loadCurrentIndex() {
    var test = StorageService().read(
      "${StorageService.test}-${widget.section.test_id}",
    );
    if (test != null && test['current_index'] != null) {
      setState(() {
        item_index = test['current_index'];
      });
    }
  }

  // Save current question index to storage
  void saveCurrentIndex() {
    var test = StorageService().read(
      "${StorageService.test}-${widget.section.test_id}",
    );
    if (test != null) {
      test['current_index'] = item_index;
      StorageService().write(
        "${StorageService.test}-${widget.section.test_id}",
        test,
      );
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
    print('🟡 [test_screen] getTestsFromStorage chaqirildi, items.length=${items.length}');
    
    var test = StorageService().read(
      "${StorageService.test}-${widget.section.test_id}",
    );

    if (test == null) {
      print('🟡 [test_screen] Storage da malumot yoq, yangi test yaratilmoqda...');
      print('🟡 [test_screen] groupData holati: ${groupData != null ? "mavjud" : "NULL"}');
      if (groupData != null) {
        print('🟡 [test_screen] groupData: hasTime=${groupData?["hasTime"]}, timeMinutes=${groupData?["timeMinutes"]}, fullTime=${groupData?["fullTime"]}');
      }
      
      var resItems = [];
      math.Random random = math.Random();

      items.shuffle(random);
      var len = items.length;

      for (var i = 0; i < len; i++) {
        var item = items[i];
        
        // Collect all valid answers
        var allAnswers = <String, String>{};
        if (item["answer_A"] != null && item["answer_A"].toString().isNotEmpty) {
          allAnswers["A"] = item["answer_A"].toString();
        }
        if (item["answer_B"] != null && item["answer_B"].toString().isNotEmpty) {
          allAnswers["B"] = item["answer_B"].toString();
        }
        if (item["answer_C"] != null && item["answer_C"].toString().isNotEmpty) {
          allAnswers["C"] = item["answer_C"].toString();
        }
        if (item["answer_D"] != null && item["answer_D"].toString().isNotEmpty) {
          allAnswers["D"] = item["answer_D"].toString();
        }
        
        // Check if last answer is special
        var answerKeys = allAnswers.keys.toList();
        String? specialAnswerKey;
        String? specialAnswerValue;
        
        if (answerKeys.isNotEmpty) {
          var lastKey = answerKeys.last;
          var lastValue = allAnswers[lastKey];
          if (_isSpecialAnswer(lastValue)) {
            specialAnswerKey = lastKey;
            specialAnswerValue = lastValue;
            allAnswers.remove(lastKey);
            answerKeys.remove(lastKey);
          }
        }
        
        // Original shuffle logic for non-special answers
        var ans = item["answer"] ?? "";
        var ansText = allAnswers[ans] ?? item["answer_" + ans];
        allAnswers.remove(ans);  // To'g'ri javobni olib tashlash
        answerKeys.remove(ans);  // To'g'ri javob kalitini ro'yxatdan olib tashlash
        
        var rightIndex = random.nextInt(4);
        var availableKeys = ["A", "B", "C", "D"];
        var rightAnswer = availableKeys[rightIndex];
        
        var extraItem = <String, String>{};
        extraItem["answer_$rightAnswer"] = ansText;
        
        // Shuffle remaining answer keys
        answerKeys.shuffle(random);
        
        // Assign remaining answers to available keys
        int keyIndex = 0;
        for (var key in availableKeys) {
          if (key == rightAnswer) continue;  // Skip to'g'ri javob pozitsiyasi
          if (keyIndex < answerKeys.length) {
            extraItem["answer_$key"] = allAnswers[answerKeys[keyIndex]] ?? "";
            keyIndex++;
          }
        }
        
        // Add special answer at the end if exists
        if (specialAnswerKey != null && specialAnswerValue != null) {
          var allKeys = ["A", "B", "C", "D"];
          // Find the unused key
          for (var key in allKeys) {
            if (!extraItem.containsKey("answer_$key")) {
              extraItem["answer_$key"] = specialAnswerValue;
              break;
            }
          }
        }

        resItems.add({
          "number": i + 1,
          "question": item["question"] ?? "",
          "answer_A": extraItem["answer_A"] ?? "",
          "answer_B": extraItem["answer_B"] ?? "",
          "answer_C": extraItem["answer_C"] ?? "",
          "answer_D": extraItem["answer_D"] ?? "",
          "answer": rightAnswer,
          "createdt": item["createdt"],
          "updatedAt": item["updatedAt"],
          "test_id": item["test_id"],
        });

        //
      }

      var now = DateTime.now();
      int finishTime = getFinishTime(resItems.length); // in seconds
      print('🟢 [test_screen] finishTime hisoblandi: ${finishTime}s (${finishTime ~/ 60}min)');

      Map? data = {
        "time": now.toString(),
        "finish_time": now.add(Duration(seconds: finishTime)).toString(),
        "data": resItems,
        "section": {
          "id": widget.section.id,
          "test_id": widget.section.test_id,
          "name": widget.section.name,
          "count": widget.section.count,
          "percent": widget.section.percent,
        },
      };

      StorageService().write(
        "${StorageService.test}-${widget.section.test_id}",
        data,
      );
      return data;
    }
    print('🟢 [test_screen] Storage dan malumot topildi');
    return test;
  }

  Timer? timer;
  Timer? perQuestionTimer;
  int perQuestionRemainingTime = 0;
  Map<String, dynamic>? groupData;
  bool _timersStarted = false;

  bool isPerQuestionTime() {
    if (groupData == null) return false;
    bool hasTime = groupData?["hasTime"] ?? false;
    if (!hasTime) return false;

    int fullTime = groupData?["fullTime"] ?? 0;
    int timeMinutes = groupData?["timeMinutes"] ?? 0;
    bool forceNext = groupData?["forceNextQuestion"] ?? false;
    
    // Faqat forceNextQuestion=true bo'lganda har bir savol uchun alohida timer
    // false bo'lsa umumiy vaqt ko'rsatamiz
    return fullTime == 0 && timeMinutes > 0 && forceNext;
  }

  String formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  getFinishTime(int count) {
    if (groupData == null) return 0;
    bool hasTime = groupData?["hasTime"] ?? false;

    if (!hasTime) return 0; // Timer yo'q

    int fullTime = groupData?["fullTime"] ?? 0;
    int timeSeconds = groupData?["timeMinutes"] ?? 0; // Backend nomi: timeMinutes, lekin bu SEKUNDLAR!

    // fullTime > 0 bo'lsa, umumiy vaqt (minutlarda -> sekundga)
    if (fullTime > 0) {
      return fullTime * 60;
    }
    // fullTime == 0 bo'lsa, har bir savol uchun timeSeconds (allaqachon sekundlarda)
    else if (timeSeconds > 0) {
      return timeSeconds * count;  // * 60 yo'q, chunki backend sekund jo'natadi!
    }

    return 0;
  }

  Future<void> _loadGroupData() async {
    print('🟢 [test_screen] _loadGroupData boshlanmoqda...');
    final group = await StudentController.getMyGroup(context);
    print('🟢 [test_screen] Guruh malumoti: $group');
    if (group != null && mounted) {
      setState(() {
        groupData = group;
      });
      print('🟢 [test_screen] groupData ornatildi: hasTime=${groupData?["hasTime"]}, timeMinutes=${groupData?["timeMinutes"]}, fullTime=${groupData?["fullTime"]}');
    } else {
      print('🔴 [test_screen] Guruh malumoti null yoki widget unmounted');
    }
  }

  void _startTimersIfNeeded() {
    print('🟡 [test_screen] _startTimersIfNeeded: _timersStarted=$_timersStarted, groupData=${groupData != null}, test_items.length=${test_items.length}');
    
    if (_timersStarted) {
      print('⚠️ [test_screen] Timer allaqachon ishga tushgan');
      return;
    }
    
    if (groupData == null) {
      print('⚠️ [test_screen] groupData null');
      return;
    }
    
    if (test_items.isEmpty) {
      print('⚠️ [test_screen] test_items bosh');
      return;
    }

    bool hasTime = groupData?["hasTime"] ?? false;
    print('🟡 [test_screen] hasTime=$hasTime');
    
    if (!hasTime) {
      print('⚠️ [test_screen] Guruhda vaqt yoq (hasTime=false)');
      return;
    }

    _timersStarted = true;
    print('🟢 [test_screen] Timer ishga tushmoqda...');

    // Har bir savol uchun vaqt bo'lsa
    if (isPerQuestionTime()) {
      // DIQQAT: Backend 'timeMinutes' deb nomlagan lekin bu aslida SEKUNDLAR!
      int timeSeconds = groupData?["timeMinutes"] ?? 0;
      
      // Storage dan oldingi savolning qolgan vaqtini yuklash
      if (perQuestionRemainingTime == 0) {
        var storageData = StorageService().read(
          "${StorageService.test}-${widget.section.test_id}",
        );
        int savedTime = storageData?["per_question_time"] ?? 0;
        
        if (savedTime > 0) {
          perQuestionRemainingTime = savedTime;
          print('🟡 [test_screen] Storage dan yuklandi: ${formatTime(perQuestionRemainingTime)}');
        } else {
          perQuestionRemainingTime = timeSeconds;  // timeMinutes aslida sekund!
          print('🟢 [test_screen] Yangi timer: ${formatTime(perQuestionRemainingTime)}');
        }
      }
      print('🟢 [test_screen] Per-question timer: ${timeSeconds}s (${formatTime(perQuestionRemainingTime)})');
      
      bool forceNext = groupData?["forceNextQuestion"] ?? false;
      print('🟡 [test_screen] forceNextQuestion: $forceNext');

      perQuestionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          if (perQuestionRemainingTime <= 0) {
            // Vaqt tugadi
            print('⚠️ [test_screen] Vaqt tugadi! forceNextQuestion=$forceNext');
            
            if (forceNext) {
              // Majburiy o'tish - avtomatik keyingi savolga
              var count = test_items.length;
              if (item_index < count - 1) {
                setState(() {
                  item_index++;
                  perQuestionRemainingTime = timeSeconds;
                  saveCurrentIndex();
                });
              } else {
                // Oxirgi savol, testni tugatish
                timer.cancel();
                _finishTest();
              }
            } else {
              // forceNextQuestion=false - timer to'xtaydi, o'tish uchun tugma bosish kerak
              perQuestionRemainingTime = 0;
              timer.cancel();
              print('⚠️ [test_screen] Timer to\'xtadi, foydalanuvchi o\'zi keyingi savolga o\'tishi kerak');
              setState(() {});
            }
          } else {
            perQuestionRemainingTime--;
            setState(() {});
          }
        }
      });
    } else if (remainingTime > 0) {
      // Umumiy vaqt uchun timer
      print('🟢 [test_screen] Full test timer: ${remainingTime}s');
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
    } else {
      print('⚠️ [test_screen] remainingTime <= 0, timer ishga tushmaydi');
    }
  }

  Future<void> _finishTest() async {
    var count = test_items.length;
    var results = getAnswers(count);
    var storageData = StorageService().read(
      "${StorageService.test}-${widget.section.test_id}",
    );
    String? startTime = storageData?["time"];
    String? finishTime = storageData?["finish_time"];

    await ResultController.post(
      context,
      solved: rightAnswer(test_items),
      test_id: int.tryParse(widget.section.test_id.toString()) ?? 0,
      startTime: startTime,
      finishTime: finishTime,
      answers:
          test_items
              .map(
                (e) => {
                  ...(e as Map),
                  "my_answer": results[e["number"].toString()],
                },
              )
              .toList(),
    );
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

  // int currentQuestion = 0;
  // int totalQuestions = 30;

  int remainingTime = 3599;
  List test_items = [];
  // int remainingTime = 900; // 15 daqiqa

  LoadingService loadingService = LoadingService();
  ToastService toastService = ToastService();
  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Testni tugatish",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Testni tugatmoqchimisiz? Barcha javoblaringiz saqlanadi.",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                "Yo'q",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Ha",
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
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Android back button: go to previous question
        if (item_index > 0) {
          setState(() {
            item_index--;
            saveCurrentIndex();
          });
          return false; // Don't pop the route
        }
        // On first question, show confirmation dialog
        return await _showExitDialog();
      },
      child: Scaffold(
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
          leading: IconButton(
            onPressed: () {
              // AppBar back button: exit completely
              Navigator.pop(context);
            },
          icon: Center(
            child: Container(
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
      body: BlocListener<TestBloc, TestState>(
        child: bodySection(),
        listener: (context, state) async {
          if (state is TestErrorState) {
            if (state.statusCode == 401) {
              Logout(context);
            } else {
              toastService.error(message: state.message ?? "Xatolik Bor");
            }
          } else if (state is TestSuccessState) {
            // await StorageService().remove(
            //   "${StorageService.test}-${widget.section.test_id}",
            // );
          }
        },
      ),
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        if (state is TestSuccessState) {
          print('🟢 [test_screen] TestSuccessState keldi, test_items yuklanyapti...');
          Map? storageData = getTestsFromStorage(
            state.data["test_items"] ?? [],
          );

          test_items = storageData?["data"] ?? [];
          print('🟢 [test_screen] test_items yuklandi: ${test_items.length} ta savol');
          
          // Test ma'lumotlari tayyor bo'lganda timerlarni ishga tushirish
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('🟢 [test_screen] PostFrameCallback: _startTimersIfNeeded chaqirilmoqda...');
            _startTimersIfNeeded();
          });
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
          var test = test_items[item_index];
          var count = test_items.length;
          var results = getAnswers(count);

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
                              // Timer faqat ma'lumotlar tayyor bo'lganda ko'rsatish
                              if (groupData != null && (groupData!["hasTime"] ?? false) && _timersStarted)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        (isPerQuestionTime()
                                                    ? perQuestionRemainingTime
                                                    : remainingTime) >
                                                5
                                            ? AppConstant.blueColor1.withOpacity(0.15)
                                            : AppConstant.redColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16.sp,
                                        color:
                                            (isPerQuestionTime()
                                                        ? perQuestionRemainingTime
                                                        : remainingTime) >
                                                    5
                                                ? AppConstant.blueColor1
                                                : AppConstant.redColor,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isPerQuestionTime()
                                            ? "Savol vaqti: ${formatTime(perQuestionRemainingTime)}"
                                            : remainingTime >= 0
                                            ? "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"
                                            : "00:00",
                                        style: TextStyle(
                                          color:
                                              (isPerQuestionTime()
                                                          ? perQuestionRemainingTime
                                                          : remainingTime) >
                                                      5
                                                  ? AppConstant.blueColor1
                                                  : AppConstant.redColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (groupData != null && (groupData!["hasTime"] ?? false) && _timersStarted)
                                SizedBox(width: 12.w),
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
                                    final selectedAnswer = ["A", "B", "C", "D"][index];
                                    await writeAnswer(
                                      count,
                                      index: item_index,
                                      result: selectedAnswer,
                                    );
                                    setState(() {
                                      answer = selectedAnswer;
                                    });
                                    
                                    // Vibrate on wrong answer (mobile only)
                                    if (!kIsWeb && selectedAnswer != test["answer"]) {
                                      try {
                                        if (await Vibration.hasVibrator() ?? false) {
                                          Vibration.vibrate(duration: 100);
                                        }
                                      } catch (e) {
                                        print('Vibration error: $e');
                                      }
                                    }
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
                          !(groupData?["forceNextQuestion"] ?? false))
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
                                      int timeSeconds =
                                          groupData?["timeMinutes"] ?? 0; // Backend: timeMinutes = SEKUNDLAR!
                                      perQuestionRemainingTime =
                                          timeSeconds; // * 60 yo'q!
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

                      if (item_index > 0)
                        // forceNextQuestion=true bo'lsa orqaga qaytish yo'q
                        if (!(groupData?["forceNextQuestion"] ?? false))
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
                                borderRadius: BorderRadius.circular(12.r),
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
        } else if (state is TestWaitingState) {
          return CommonLoading(message: "Ma'lumot yuklanmoqda...");
        } else {
          return SizedBox();
        }
      },
    );
  }
}
