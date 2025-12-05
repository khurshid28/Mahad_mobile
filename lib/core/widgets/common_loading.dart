import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_app/core/const/const.dart';

class CommonLoading extends StatelessWidget {
  final String? message;
  
  const CommonLoading({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(
            color: AppConstant.primaryColor,
            size: 50.w,
          ),
          SizedBox(height: 20.h),
          Text(
            message ?? "Yuklanmoqda...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppConstant.greyColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
