// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';

import 'package:intl/intl.dart';


class ResultCard extends StatelessWidget {
  final Result result;
  final int count;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  ResultCard({required this.result, required this.onTap,required this.count});
  bool isFailed() {
    if (result.solved == null || count == 0) return false;
    return 0.56 > (result.solved! / count);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppConstant.primaryColor.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstant.primaryColor.withOpacity(0.15),
                        AppConstant.primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    result.finished ? Icons.check_circle_outline : Icons.access_time,
                    color: AppConstant.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  DateFormat('dd.MM.yyyy').format(result.date),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            result.finished
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isFailed()
                              ? ((result.solved ?? 0) != 0 
                                  ? AppConstant.redColor.withOpacity(0.1) 
                                  : Colors.grey.shade100)
                              : AppConstant.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${result.solved ?? 0}/$count",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isFailed()
                                ? ((result.solved ?? 0) != 0 
                                    ? AppConstant.redColor 
                                    : Colors.grey.shade500)
                                : AppConstant.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppConstant.primaryColor,
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "Tugatilmagan",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
