// ignore_for_file: deprecated_member_use


import '../../export_files.dart';
class LoadingService {
  showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppConstant.primaryColor.withOpacity(0.3),
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          content:
          
           SizedBox(
            width: 160.w,
            height: 160.w,
            child: Center(
              child: CircularProgressIndicator(
                  color:AppConstant.primaryColor,
                  strokeWidth: 6.w,
                  strokeAlign: 2,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppConstant.primaryColor.withOpacity(0.2),
                ),
            ),
          ),
        ),
      ),
    );
  }

  closeLoading(BuildContext context) {
    Navigator.pop(context);
  }
}
