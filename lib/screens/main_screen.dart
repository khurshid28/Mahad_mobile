// ignore_for_file: deprecated_member_use

import 'package:test_app/export_files.dart';
import 'package:test_app/screens/book/books_body.dart';
import 'package:test_app/screens/book/books_screen.dart';
import 'package:test_app/screens/home/home_screen.dart';
import 'package:test_app/screens/profile.dart';
import 'package:test_app/screens/saved/saved_body.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  List<String> appBarTitle = ['Asosiy', 'Kitoblar', 'Saqlanganlar', 'Profil'];
  List<Map<String, String>> svgIcon = [
    {'main': 'assets/icons/house.svg', 'mainfill': 'assets/icons/housefill.svg'},
    {
      'contract': 'assets/icons/magazine.svg',
      'contractfill': 'assets/icons/magazinefill.svg',
    },
    {
      'heart': 'assets/icons/heart.svg',
      'heartfill': 'assets/icons/heartfill.svg',
    },
    {
      'profile': 'assets/icons/person.svg',
      'profilefill': 'assets/icons/personfill.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          titleText: appBarTitle[currentIndex],
          isLeading: false,
        ),
      ),
      body: selectBody(currentIndex),
      // drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      // drawerEnableOpenDragGesture: true,
      // drawerScrimColor: Colors.black38,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstant.whiteColor,
        selectedItemColor: AppConstant.primaryColor,
        unselectedItemColor: AppConstant.blackColor,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon:
                currentIndex != 0
                    ? SvgPicture.asset(svgIcon[0]['main'].toString())
                    : SvgPicture.asset(svgIcon[0]['mainfill'].toString()),
            label: 'Asosiy',
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 1
                    ? SvgPicture.asset(svgIcon[1]['contract'].toString())
                    : SvgPicture.asset(svgIcon[1]['contractfill'].toString()),
            label: 'Kitoblar',
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 2
                    ? SvgPicture.asset(svgIcon[2]['heart'].toString())
                    : SvgPicture.asset(svgIcon[2]['heartfill'].toString()),
            label: "Saqlanganlar",
          ),
          BottomNavigationBarItem(
            icon:
                currentIndex != 3
                    ? SvgPicture.asset(svgIcon[3]['profile'].toString())
                    : SvgPicture.asset(svgIcon[3]['profilefill'].toString()),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  selectBody<Widget>(int currentIndex) {
    
if (currentIndex==0) {
      return  HomeScreen();
    }
    else if (currentIndex==1) {
      return  BooksBody();
    }
     else if (currentIndex==2) {
      return  SavedBody();
    }

   else if (currentIndex==3) {
      return const ProfileScreen();
    }
    return HomeScreen();
    
    // if (currentIndex == 0) {
    //   return const HomeScreen();
    // } else if (currentIndex == 1) {
    //   return const DocumentScreen();
    // } else if (currentIndex == 2) {
    //   return const MarketScreen();
    // } else if (currentIndex == 3) {
    //   return const ProfileScreen();
    // }
  }
}
