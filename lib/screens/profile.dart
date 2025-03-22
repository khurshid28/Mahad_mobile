import 'package:test_app/export_files.dart';
import 'package:test_app/screens/my_result/my_result_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  'assets/images/profile.jpg',
                  width: 110.w,
                  height: 110.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Xurshid Ismoilov',
              style: TextStyle(
                color: AppConstant.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '+998 95 064 28 27',
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
                            // showAboutDialog(context: context);
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
              'Ilova versiyasi: 1.0.2',
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
