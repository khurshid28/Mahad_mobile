import 'package:test_app/export_files.dart';
import 'package:test_app/screens/main_screen.dart';

class FinishTestScreen extends StatefulWidget {
  int right;
  int count;
  FinishTestScreen({super.key, required this.count, required this.right});

  @override
  _FinishTestScreenState createState() => _FinishTestScreenState();
}

class _FinishTestScreenState extends State<FinishTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [
                    AppConstant.primaryColor,
                    AppConstant.primaryColor.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstant.primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, color: Colors.white, size: 24.w),
                      SizedBox(width: 8.w),
                      Text(
                        "Asosiy oynaga qaytish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
