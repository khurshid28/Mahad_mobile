// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:test_app/core/const/const.dart';
// import 'package:test_app/models/subject.dart';
// import 'package:test_app/widgets/subject_card.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Subject> subjects = [
//     Subject(name: "Tarix", imagePath: "assets/images/history.png"),
//     Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
//     Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
//   ];

//   final List<Color> backgroundColors = [
//     Color(0xFFEAF8E5), // Yashil fon
//     Color(0xFFFFF0E5), // Apelsin fon
//     Color(0xFFFFE5E5), // Qizil fon
//   ];

//   final List<Color> borderColors = [
//     Color(0xFF4CAF50), // Yashil ramka (Tarix)
//     Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
//     Color(0xFFF44336), // Qizil ramka (Matematika)
//   ];

//   List<Subject> filteredSubjects = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredSubjects = subjects;
//   }

//   void _filterSubjects(String query) {
//     setState(() {
//       filteredSubjects = subjects
//           .where((subject) =>
//               subject.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppConstant.whiteColor,
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: _filterSubjects,
//               decoration: InputDecoration(
//                 hintText: "Fan qidirish",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.9,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: filteredSubjects.length,
//                 itemBuilder: (context, index) {
//                   return SubjectCard(
//                     subject: filteredSubjects[index],
//                     backgroundColor: backgroundColors[index % backgroundColors.length],
//                     borderColor: borderColors[index % borderColors.length],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/books_screen.dart';
import 'package:test_app/widgets/custom_text_field.dart';
import 'package:test_app/widgets/subject_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Subject> subjects = [
    Subject(name: "Tarix", imagePath: "assets/images/history.png"),
    Subject(name: "Adabiyot", imagePath: "assets/images/adabiyot.png"),
    Subject(name: "Matematika", imagePath: "assets/images/matematika.png"),
  ];

  final List<Color> backgroundColors = [
    Color(0xFFEAF8E5), // Yashil fon
    Color(0xFFFFF0E5), // Apelsin fon
    Color(0xFFFFE5E5), // Qizil fon
  ];

  final List<Color> borderColors = [
    Color(0xFF4CAF50), // Yashil ramka (Tarix)
    Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
    Color(0xFFF44336), // Qizil ramka (Matematika)
  ];

  List<Subject> filteredSubjects = [];

  @override
  void initState() {
    super.initState();
    filteredSubjects = subjects;
  }

  void _filterSubjects(String query) {
    setState(() {
      filteredSubjects = subjects
          .where((subject) =>
              subject.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  TextEditingController seachController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: AppConstant.primaryColor,
              onChanged: _filterSubjects,
              
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
                fillColor: Colors.grey.shade200,
                filled: true,
                
                hintText: "Fan qidirish",
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400
                ),
                prefixIcon:  Padding(
                  padding:  EdgeInsets.only(left: 17.w,right: 8.w,top: 10.w,bottom: 10.w),
                  
                  child: SvgPicture.asset("assets/icons/search.svg",width: 10.w,height: 10.h,color: Colors.grey.shade600,),
                ) ,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredSubjects.length,
                itemBuilder: (context, index) {
                  return SubjectCard(
                    subject: filteredSubjects[index],
                    backgroundColor: backgroundColors[index % backgroundColors.length],
                    borderColor: borderColors[index % borderColors.length],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BooksScreen(
                              subject: filteredSubjects[index],
                            ),
                          ),
                        );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

