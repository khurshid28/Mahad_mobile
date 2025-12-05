// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:intl/intl.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';

class MyResultCard extends StatelessWidget {
   final Result result;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  MyResultCard({ required this.onTap,required this.result});

  int get test_count  =>result.test["_count"]?["test_items"] ?? 1;
  bool isFailed() {
    if (result.solved == null) return false;
    return 0.56 > (result.solved! / test_count);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = test_count > 0 ? (result.solved! / test_count * 100) : 0;
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
                    AppConstant.primaryColor,
                    AppConstant.primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppConstant.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.menu_book_rounded,
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
                  Text(
                    "${result.test?["section"]?["book"]?["subject"]?["name"]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          "${result.test?["section"]?["book"]?["name"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
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
                    "${result.solved ?? 0}/$test_count",
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
