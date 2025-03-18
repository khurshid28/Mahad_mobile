import 'package:test_app/export_files.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
    required this.titleText,
    required this.isLeading,
  });
  String titleText;
  bool isLeading;
  @override
  Widget build(BuildContext context) {
    return
    
     AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppConstant.whiteColor,
      title: Text(
              titleText,
              style: TextStyle(
                color: AppConstant.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
      centerTitle: true,
      leading: isLeading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/chevronleft.svg',
                width: 22.w,
                colorFilter: const ColorFilter.mode(
                  AppConstant.blackColor,
                  BlendMode.srcIn,
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
