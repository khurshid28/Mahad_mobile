// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
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
    return 0.56 > (result.solved / count);
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
                  Text(
                              DateFormat('dd.MM.yyyy').format(result.date),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

           result.finished ?        Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                         "${result.solved}/${count}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              isFailed()
                                  ? (result.solved !=0 ?  AppConstant.redColor :Colors.grey.shade400 )
                                  : AppConstant.primaryColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SvgPicture.asset(
                        "assets/icons/chevronright.svg",
                        width: 25.w,
                      ),
                    ],
                  )
              :    Text(
                              "Tugatilmagan",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
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
