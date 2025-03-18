// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';

class SectionCard extends StatelessWidget {
  final Section section;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  SectionCard({required this.section, required this.onTap});
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
                              "${section.solved}/${section.count}",
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
                        "${((section.solved / section.count) * 100).round()}%",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isFailed()
                                  ? (section.solved !=0 ?  AppConstant.redColor :Colors.grey.shade400 )
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
