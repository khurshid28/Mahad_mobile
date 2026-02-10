// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';

class SectionCard extends StatelessWidget {
  final Section section;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  bool block;
  bool isFailed;
  final int passingPercentage;
  SectionCard({
    required this.section,
    required this.onTap,
    this.block = false,
    this.isFailed = false,
    this.passingPercentage = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  block
                      ? Colors.grey.shade300
                      : (isFailed
                          ? AppConstant.redColor.withOpacity(0.3)
                          : Theme.of(context).primaryColor.withOpacity(0.3)),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      block
                          ? Colors.grey.shade100
                          : (isFailed
                              ? AppConstant.redColor.withOpacity(0.1)
                              : Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  "assets/icons/magazinefill.svg",
                  width: 24.w,
                  color:
                      block
                          ? Colors.grey.shade400
                          : (isFailed
                              ? AppConstant.redColor
                              : Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      section.name ?? "",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            block
                                ? Colors.grey.shade400
                                : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${section.count} ta test",
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (!block) ...[
                SizedBox(width: 12.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isFailed
                            ? AppConstant.redColor.withOpacity(0.1)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${section.percent.round()}/$passingPercentage",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isFailed
                                  ? AppConstant.redColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "%",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isFailed
                                  ? AppConstant.redColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18.w,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
              if (block)
                Icon(
                  Icons.lock_rounded,
                  size: 24.w,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
