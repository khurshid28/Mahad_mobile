// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';

class MyResultCard extends StatelessWidget {
  final Section section;
   final Result result;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  MyResultCard({required this.section, required this.onTap,required this.result});
  bool isFailed() {
    return 0.56 > (section.solved / section.count);
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
                    // color: Colors.red.shade300,
                    width: 270.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/magazinefill.svg",
                          width: 35.w,
                        ),
                        SizedBox(width: 20.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              section.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
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
                      ],
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${result.solved}/${section.count}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isFailed()
                                  ?  AppConstant.redColor  
                                  : AppConstant.primaryColor,
                        ),
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
