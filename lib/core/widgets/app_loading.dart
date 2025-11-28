import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_app/core/const/const.dart';

class AppLoading {
  // Circular Loading with primary color
  static Widget circular({Color? color, double? size}) {
    return SpinKitCircle(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Fading Circle Loading
  static Widget fadingCircle({Color? color, double? size}) {
    return SpinKitFadingCircle(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Three Bounce Loading (like splash screen)
  static Widget threeBounce({Color? color, double? size}) {
    return SpinKitThreeBounce(
      color: color ?? AppConstant.whiteColor,
      size: size ?? 24.w,
    );
  }

  // Pulse Loading
  static Widget pulse({Color? color, double? size}) {
    return SpinKitPulse(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Wave Loading
  static Widget wave({Color? color, double? size}) {
    return SpinKitWave(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 40.w,
      itemCount: 5,
    );
  }

  // Rotating Circle Loading
  static Widget rotatingCircle({Color? color, double? size}) {
    return SpinKitRotatingCircle(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Fading Four Loading
  static Widget fadingFour({Color? color, double? size}) {
    return SpinKitFadingFour(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Wandering Cubes Loading
  static Widget wanderingCubes({Color? color, double? size}) {
    return SpinKitWanderingCubes(
      color: color ?? AppConstant.primaryColor,
      size: size ?? 50.w,
    );
  }

  // Custom Gradient Loading
  static Widget gradientCircular({double? size}) {
    return Container(
      width: size ?? 50.w,
      height: size ?? 50.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppConstant.primaryColor,
            AppConstant.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: CircularProgressIndicator(
          strokeWidth: 3.w,
          valueColor: AlwaysStoppedAnimation<Color>(AppConstant.whiteColor),
        ),
      ),
    );
  }

  // Full Screen Loading Dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppConstant.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppConstant.blackColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                fadingCircle(),
                if (message != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppConstant.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Close Loading Dialog
  static void closeLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // Center Loading Widget
  static Widget center({Widget? child}) {
    return Center(
      child: child ?? fadingCircle(),
    );
  }

  // Loading with message
  static Widget withMessage(String message, {Widget? loadingWidget}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadingWidget ?? fadingCircle(),
        SizedBox(height: 16.h),
        Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppConstant.blackColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
