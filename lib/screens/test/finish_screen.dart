import 'package:test_app/export_files.dart';
import 'package:test_app/screens/main_screen.dart';

class FinishTestScreen extends StatefulWidget {
  int right;
  int count;
  FinishTestScreen({required this.count, required this.right});

  @override
  _FinishTestScreenState createState() => _FinishTestScreenState();
}

class _FinishTestScreenState extends State<FinishTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/finish_test.jpg", width: 270.w),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 240.w,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Siz testdan ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.right}/${widget.count}',
                            style: TextStyle(
                              color: AppConstant.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                            ),
                          ),
                          TextSpan(
                            text: ' natija ko’rsatdingiz',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor:AppConstant.primaryColor,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.r),
                //       ),
                //       padding: EdgeInsets.symmetric(vertical: 14.h),
                //     ),
                //     onPressed: () {},
                //     child: Center(
                //       child: Text(
                //         "Davom qilish",
                //         style: TextStyle(color: Colors.white, fontSize: 16.sp),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        "Asosiy oynaga qaytish",
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
