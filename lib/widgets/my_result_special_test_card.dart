// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:intl/intl.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';

class MyResultSpecialTestCard extends StatelessWidget {
  final Result result;
  final Map<String, dynamic> specialTest;
  final VoidCallback onTap;
  
  MyResultSpecialTestCard({
    required this.onTap,
    required this.result,
    required this.specialTest,
  });

  int get questionCount => specialTest["question_count"] ?? 0;
  
  bool isFailed() {
    if (result.solved == null || questionCount == 0) return false;
    return 0.56 > (result.solved! / questionCount);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = questionCount > 0 ? (result.solved! / questionCount * 100) : 0;
    final isPassed = percentage >= 56;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPassed ? Colors.green.shade200 : Colors.red.shade200,
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
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9C27B0),
                    Color(0xFF9C27B0).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9C27B0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9C27B0).withOpacity(0.2),
                          Color(0xFF9C27B0).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "MAXSUS TEST",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9C27B0),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    specialTest["name"] ?? "Maxsus Test",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "$questionCount savol",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        DateFormat('dd.MM').format(result.date),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPassed
                          ? [Colors.green.shade400, Colors.green.shade300]
                          : [Colors.red.shade400, Colors.red.shade300],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "${result.solved ?? 0}/$questionCount",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: AppConstant.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
