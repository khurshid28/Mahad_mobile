import 'package:test_app/export_files.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/test/finish_screen.dart';
import 'package:test_app/theme/app_colors.dart';

class TestScreen extends StatefulWidget {
  final Section section;
  TestScreen({required this.section});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int answer = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppConstant.whiteColor,
        title: Text(
          "Angliya XII asr",
          style: TextStyle(
            color: AppConstant.blackColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/close.svg',
            width: 18.w,
            colorFilter: const ColorFilter.mode(
              AppConstant.blackColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 1.sw - 64,
                    child: Text(
                      "23.Loy jangi qachon bo’lib o’tgan ?",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

                  ...List.generate(4, (index)=>     GestureDetector(
                    onTap: ()=>setState(() {
                      answer = index;
                    }),
                    child: Container(
                      width: 1.sw-32,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          children: [
                            index == answer ? Container(
                              width: 32.w,
                              height: 32.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppConstant.primaryColor,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/check.svg',
                                width: 18.w,
                                colorFilter: const ColorFilter.mode(
                                  AppConstant.whiteColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ) : 
                            Container(
                              width: 32.w,
                              height: 32.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                  width: 3.w
                                )
                              ),
                             
                            ),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 305.w,
                              child: Text("${1469-index}-yil", style: TextStyle()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
               )
              ],
              ),
            ),
          ),

          SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                                builder: (context) => FinishTestScreen(),
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
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        "Orqaga qaytish",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
