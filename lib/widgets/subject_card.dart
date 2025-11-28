// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final Color backgroundColor;
  final Color borderColor; // Har bir subject uchun alohida border rangi
 final VoidCallback onTap;
  SubjectCard({
    required this.subject,
    required this.backgroundColor,
    required this.borderColor, required   this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark 
              ? backgroundColor.withOpacity(0.2) 
              : backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isDark 
                ? borderColor.withOpacity(0.5)
                : borderColor, 
            width: 1.5.w,
          ), // Fanning o'ziga mos rang
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                subject.imagePath,
                height: 80.w,
                width: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              subject.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
