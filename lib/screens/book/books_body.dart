

import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:test_app/widgets/custom_text_field.dart';
import 'package:test_app/widgets/subject_card.dart';

class BooksBody extends StatefulWidget {
  @override
  _BooksBodyState createState() => _BooksBodyState();
}

class _BooksBodyState extends State<BooksBody> {
  final List<Book> books = [
    Book(name: "Germaniya tarixi", imagePath: "assets/images/history.png"),
    Book(name: "Angliya tarixi", imagePath: "assets/images/adabiyot.png"),
    Book(name: "O'rta Osiyo tarixi", imagePath: "assets/images/matematika.png"),
     Book(name: "Fransiya tarixi", imagePath: "assets/images/matematika.png"),
  ];

  final List<Color> backgroundColors = [
    Color(0xFFEAF8E5), // Yashil fon
    Color(0xFFFFF0E5), // Apelsin fon
    Color(0xFFFFE5E5), // Qizil fon

     Color.fromARGB(255, 204, 203, 246),
  ];

  final List<Color> borderColors = [
    Color(0xFF4CAF50), // Yashil ramka (Tarix)
    Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
    Color(0xFFF44336), // Qizil ramka (Matematika)
     Color.fromARGB(255, 124, 118, 240),
  ];

  List<Book> filteredbooks = [];

  @override
  void initState() {
    super.initState();
    filteredbooks = books;
  }

  void _filterbooks(String query) {
    setState(() {
      filteredbooks = books
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
              onChanged: _filterbooks,
              
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
                fillColor: Colors.grey.shade200,
                filled: true,
                
                hintText: "Kitob qidirish",
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: filteredbooks[index%borderColors.length],
                    backgroundColor: backgroundColors[index % backgroundColors.length],
                    borderColor: borderColors[index % borderColors.length],
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookScreen(book: filteredbooks[index%borderColors.length],),
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

