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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(test_items.length, (item_index) {
        var test = test_items[item_index];

        String? answer = widget.answers[item_index]["my_answer"];
        return Padding(
          padding:  EdgeInsets.all(16.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 1.sw - 64,
                  child: Text(
                    "${test['number']}.${realText(test['question'].toString())}",
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
                  (index) => Container(
                    width: 1.sw - 32.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          ((answer?.isNotEmpty ?? false) &&
                                  ["A", "B", "C", "D"][index] == test["answer"])
                              ? Container(
                                width: 34.w,
                                height: 34.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
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
                              : answer == ["A", "B", "C", "D"][index]
                              ? Container(
                                width: 34.w,
                                height: 34.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: AppConstant.redColor,
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/close.svg',
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
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.shade500,
                                    width: 3.w,
                                  ),
                                ),
                                child: Text(
                                  ["A", "B", "C", "D"][index].toString(),
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
             
            if(test_items.length - 1  > item_index)   customDivider()
              ],
            ),
          ),
        );
      }),
    );
  }
}
