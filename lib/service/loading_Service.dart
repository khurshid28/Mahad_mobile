// ignore_for_file: deprecated_member_use

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../export_files.dart';

class LoadingService {
  showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppConstant.blackColor.withOpacity(0.4),
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppConstant.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppConstant.primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(
                  color: AppConstant.primaryColor,
                  size: 60.w,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Yuklanmoqda...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppConstant.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  closeLoading(BuildContext context) {
    Navigator.pop(context);
  }
}

