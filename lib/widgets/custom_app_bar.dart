import 'package:test_app/export_files.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
    required this.titleText,
    required this.isLeading,
    this.actions
  });
  String titleText;
  bool isLeading;
   List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return
    
     AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppConstant.whiteColor,
      actions: actions,
      title: Text(
              titleText,
              maxLines: 1,
  overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppConstant.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
      centerTitle: true,
      leading: isLeading
          ? Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppConstant.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: AppConstant.primaryColor,
                    ),
                  ),
                ),
              ),
            )
          : null,
      bottom: PreferredSize(
        preferredSize: Size(1.sw, 0),
        child: customDivider(),
      ),
    );
  }
}
