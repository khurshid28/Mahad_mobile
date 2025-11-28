import 'package:package_info_plus/package_info_plus.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/my_result/my_result_screen.dart';
import 'package:test_app/screens/settings/settings_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<IconData> tileIcon = [
    Icons.settings_outlined,
    Icons.description_outlined,
    Icons.phone_outlined,
    Icons.logout_outlined,
  ];
  List<String> tileText = [
    'Sozlamalar',
    'Mening natijalarim',
    'Biz bilan aloqa',
    'Chiqish',
  ];
  List<String> tileLink = ['/settingsScreen', '/ofertaScreen'];
  Map getUser() {
    var user = StorageService().read(StorageService.user);
    if (user != null) {
      return user;
    }
    return {"name": "", "phone": ""};
  }
  String version = "";
  Future getVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {
      
    });

  }

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Text(
                'Chiqish',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Haqiqatan ham tizimdan chiqmoqchimisiz?',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppConstant.greyColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Yo\'q',
                style: TextStyle(
                  color: AppConstant.greyColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Logout(context, message: "Logout successfully");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                'Ha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map user = getUser();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header section with gradient background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstant.primaryColor,
                  AppConstant.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  // Profile Image with shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppConstant.secondaryColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: user["imageUrl"] != null
                              ? Image.network(
                                  Endpoints.domain + user["imageUrl"].toString(),
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/profile.jpg',
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user["name"].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user["phone"].toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          
          // Menu items with cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyResultScreen(),
                          ),
                        );
                      } else if (index == tileText.length - 2) {
                        // showLicensePage(context: context);
                      } else if (index == tileText.length - 1) {
                        _showLogoutDialog(context);
                      } else {
                        Navigator.of(context).pushNamed(
                          tileLink[index],
                          arguments: tileText[index],
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: isDark ? Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ) : null,
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon with background circle
                          Container(
                            width: 45.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                              color: index == 3
                                  ? Colors.red.withOpacity(0.1)
                                  : AppConstant.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              tileIcon[index],
                              size: 24.w,
                              color: index == 3 ? Colors.red : AppConstant.primaryColor,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              tileText[index],
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 24.w,
                            color: isDark ? Colors.white.withOpacity(0.5) : AppConstant.greyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Ilova versiyasi: $version',
            style: TextStyle(
              color: AppConstant.greyColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
