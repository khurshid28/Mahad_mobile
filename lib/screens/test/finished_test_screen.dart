import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_post_bloc.dart';
import 'package:test_app/blocs/result/result_post_state.dart';
import 'package:test_app/blocs/test/test_bloc.dart';
import 'package:test_app/blocs/test/test_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/controller/test_controller.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/service/loading_service.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';

import 'dart:math' as math;

class FinishedTestScreen extends StatefulWidget {
  final Section section;
  final List answers;
  FinishedTestScreen({required this.section, required this.answers});
  @override
  _FinishedTestScreenState createState() => _FinishedTestScreenState();
}

class _FinishedTestScreenState extends State<FinishedTestScreen> {
  @override
  void initState() {
    super.initState();
    TestController.getByid(context, id: int.tryParse(widget.section.test_id.toString()) ?? 0);
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 16.h
        ),
        child: bodySection()),
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

  Widget bodySection() {
    List test_items = widget.answers;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(test_items.length, (item_index) {
        var test = test_items[item_index];

        String? answer = widget.answers[item_index]["my_answer"];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppConstant.primaryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstant.primaryColor.withOpacity(0.15),
                          AppConstant.primaryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "${test['number']}",
                      style: TextStyle(
                        color: AppConstant.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      realText(test['question'].toString()),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...List.generate(
                4,
                (index) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ((answer?.isNotEmpty ?? false) &&
                            ["A", "B", "C", "D"][index] == test["answer"])
                        ? AppConstant.primaryColor.withOpacity(0.1)
                        : (answer == ["A", "B", "C", "D"][index])
                            ? AppConstant.redColor.withOpacity(0.1)
                            : (isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ((answer?.isNotEmpty ?? false) &&
                              ["A", "B", "C", "D"][index] == test["answer"])
                          ? AppConstant.primaryColor
                          : (answer == ["A", "B", "C", "D"][index])
                              ? AppConstant.redColor
                              : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: ((answer?.isNotEmpty ?? false) &&
                                  ["A", "B", "C", "D"][index] == test["answer"])
                              ? AppConstant.primaryColor
                              : (answer == ["A", "B", "C", "D"][index])
                                  ? AppConstant.redColor
                                  : Colors.grey.shade400,
                        ),
                        child: ((answer?.isNotEmpty ?? false) &&
                                ["A", "B", "C", "D"][index] == test["answer"])
                            ? Icon(Icons.check, color: Colors.white, size: 20.sp)
                            : (answer == ["A", "B", "C", "D"][index])
                                ? Icon(Icons.close, color: Colors.white, size: 20.sp)
                                : Text(
                                    ["A", "B", "C", "D"][index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          test["answer_${["A", "B", "C", "D"][index]}"]
                              .toString(),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
