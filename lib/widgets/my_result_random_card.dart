// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:intl/intl.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';

class MyResultRandomCard extends StatelessWidget {
   final Result result;
    int count;
    final int passingPercentage;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  MyResultRandomCard({ 
    required this.onTap,
    required this.result,
    required this.count,
    this.passingPercentage = 60,
  });

  bool isFailed() {
    if (result.solved == null || count == 0) return false;
    final percentage = (result.solved! / count) * 100;
    return percentage < passingPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = count > 0 ? (result.solved! / count * 100) : 0;
    final isPassed = percentage >= passingPercentage;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPassed 
                ? Colors.green.shade200 
                : Colors.red.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isPassed ? Colors.green : Colors.red).withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstant.accentOrange,
                    AppConstant.accentOrange.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppConstant.accentOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.shuffle_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstant.accentOrange.withOpacity(0.2),
                              AppConstant.accentOrange.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "ARALASH TEST",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppConstant.accentOrange,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "$count ta savol",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        DateFormat('dd.MM.yyyy').format(result.date),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score and arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPassed
                          ? [Colors.green.shade400, Colors.green.shade300]
                          : [Colors.red.shade400, Colors.red.shade300],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: (isPassed ? Colors.green : Colors.red).withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${result.solved ?? 0}/$count",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppConstant.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppConstant.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
