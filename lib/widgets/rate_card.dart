// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/rate.dart';

class RateCard extends StatelessWidget {
  final Rate rate;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  RateCard({required this.rate, required this.onTap});
  bool IsMe() {
    return rate.rate==2;
  }

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color:IsMe() ?  AppConstant.primaryColor.withOpacity(0.2) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // color: Colors.red.shade300,
                    width: 270.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                     rate.rate <4 ?    SvgPicture.asset(
                          "assets/icons/${rate.rate}.svg",
                          width: 40.w,
                        ): Container(
                          width: 40.w,
                          height: 40.w,
                          alignment: Alignment.center,
                          child: Text(rate.rate.toString(),style: TextStyle(
                            fontSize: 14.sp,fontWeight: FontWeight.w700
                          ),),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            border: Border.all(
                              width: 4.w,
                              color: AppConstant.primaryColor
                            )
                          ),
                        ),
                        

                        SizedBox(width: 20.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rate.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                           Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               SvgPicture.asset(
                    "assets/icons/achieve.svg",
                    height: 12.h,
                  ),
                              SizedBox(
                                width: 2.w,
                              ),
                               Text(
                             
                              rate.try_count.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            ],
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
                        rate.avg.toString()+"%",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color:
                            AppConstant.blackColor,
                        ),
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
