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
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 270.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppConstant.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.assignment_outlined,
                            color: AppConstant.primaryColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                specialTest["name"] ?? "Maxsus Test",
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Maxsus test",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${result.solved ?? 0}/${questionCount}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isFailed()
                                  ? AppConstant.redColor
                                  : AppConstant.primaryColor,
                            ),
                          ),
                          Text(
                            DateFormat('dd.MM.yyyy').format(result.date),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 6.w),
                      SvgPicture.asset(
                        "assets/icons/chevronright.svg",
                        width: 25.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            customDivider(),
          ],
        ),
      ),
    );
  }
}
