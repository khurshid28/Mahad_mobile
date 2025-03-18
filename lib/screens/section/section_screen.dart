import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/test_screen.dart';
import 'package:test_app/theme/app_colors.dart';
import 'package:test_app/widgets/result_card.dart';
import 'package:test_app/widgets/section_card.dart';

class SectionScreen extends StatefulWidget {
  final Section section;
  SectionScreen({required this.section});
  @override
  _SectionScreenState createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  List<Result> results = [
      Result(date: DateTime.now(), solved: 24,finished: false),
    Result(date: DateTime.now(), solved: 24),
    Result(date: DateTime(2025, 2, 24), solved: 17),
    Result(date: DateTime(2025, 1, 10), solved: 3),
  ];
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: widget.section.name, isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1.sw,
              height: 320.h,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/icons/magazinefill.svg",
                width: 80.w,
                height: 80.h,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.section.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Jami: ${widget.section.count} ta",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                    
                  GestureDetector(
                    onTap:
                        () => setState(() {
                          liked = !liked;
                        }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child:
                            liked
                                ? SvgPicture.asset(
                                  "assets/icons/heartfill.svg",
                                  width: 35.w,
                                  height: 35.h,
                                  color: AppConstant.redColor,
                                )
                                : SvgPicture.asset(
                                  "assets/icons/heart.svg",
                                  width: 35.w,
                                  height: 35.h,
                                  color: Colors.grey.shade400,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  results.length,
                  (index) => ResultCard(
                    result: results[index],
                    count: widget.section.count,
                    onTap: () {},
                  ),
                ),
              ),
            ),
        
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            onPressed: () {
                             Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestScreen(section: widget.section,),
                          ),
                        );
                            },
                            child: Center(
                              child: Text(
                  "Davom qilish",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              ),
                            ),
                          ),
                ),
            
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            onPressed: () {
                            
                            },
                            child: Center(
                              child: Text(
                  "Yangidan boshlash",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                              ),
                            ),
                          ),
                ),
            
           
          ],
        ),
      ),
    );
  }
}
