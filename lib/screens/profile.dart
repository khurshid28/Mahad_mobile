import 'package:package_info_plus/package_info_plus.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/my_result/my_result_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> tileIcon = [
    'assets/icons/settings.svg',
    'assets/icons/doc.svg',
    'assets/icons/phone.svg',
    'assets/icons/logout.svg',
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

  @override
  Widget build(BuildContext context) {
    Map user = getUser();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppConstant.secondaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child:
                    user["imageUrl"] != null
                        ? Image.network(
                          // 'assets/images/profile.jpg',
                          Endpoints.domain + user["imageUrl"].toString(),
                          width: 110.w,
                          height: 110.w,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          'assets/images/profile.jpg',
                          width: 110.w,
                          height: 110.w,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              user["name"].toString(),
              style: TextStyle(
                color: AppConstant.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              user["phone"].toString(),
              style: TextStyle(
                color: AppConstant.greyColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 4,
              itemBuilder:
                  (context, index) => Column(
                    children: [
                      index == 0 ? const SizedBox() : customDivider(),
                      ListTile(
                        onTap: () {
                          if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyResultScreen(),
                              ),
                            );
                          }
                          if (index == tileText.length - 2) {
                            // showLicensePage(context: context);
                          } else if (index == tileText.length - 1) {
                           Logout(context,message: "Logout successfully");
                          } else {
                            Navigator.of(context).pushNamed(
                              tileLink[index],
                              arguments: tileText[index],
                            );
                          }
                        },
                        leading: SvgPicture.asset(tileIcon[index], width: 28.w),
                        title: Text(
                          tileText[index],
                          style: TextStyle(
                            color: AppConstant.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icons/chevronright.svg',
                          width: 20.w,
                          colorFilter: const ColorFilter.mode(
                            AppConstant.greyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
            const Spacer(),
            Text(
              'Ilova versiyasi: ${version}',
              style: TextStyle(
                color: AppConstant.greyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
