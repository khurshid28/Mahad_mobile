import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/controller/book_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/BookCard.dart';

class BooksScreen extends StatefulWidget {
  final Subject subject;
  BooksScreen({required this.subject});
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
 

  // final List<Color> backgroundColors = [
  //   Color(0xFFEAF8E5), // Yashil fon
  //   Color(0xFFFFF0E5), // Apelsin fon
  //   Color(0xFFFFE5E5), // Qizil fon

  //   Color.fromARGB(255, 204, 203, 246),
  // ];

  // final List<Color> borderColors = [
  //   Color(0xFF4CAF50), // Yashil ramka (Tarix)
  //   Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
  //   Color(0xFFF44336), // Qizil ramka (Matematika)
  //   Color.fromARGB(255, 124, 118, 240),
  // ];

  @override
  void initState() {
    super.initState();
    BookController.getAll(context);
  }

  List _filterBooks(List books) {
    return  books
              .where(
                (book) =>
                    book["name"].toLowerCase().contains(seachController.text.toLowerCase()),
              )
              .toList();
  }

  ToastService toastService = ToastService();
  TextEditingController seachController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: widget.subject.name, isLeading: true),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: AppConstant.primaryColor,
              onChanged: (e) => setState(() {}),
              controller: seachController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 15.h,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,

                hintText: "Kitob qidirish",
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 17.w,
                    right: 8.w,
                    top: 10.w,
                    bottom: 10.w,
                  ),

                  child: SvgPicture.asset(
                    "assets/icons/search.svg",
                    width: 10.w,
                    height: 10.h,
                    color: Colors.grey.shade600,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

             BlocListener<BookAllBloc, BookAllState>(
              child: SizedBox(),
              listener: (context, state) async {
                if (state is BookAllErrorState) {
                  if (state.statusCode == 401) {
                    Logout(context);
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is BookAllSuccessState) {}
              },
            ),
            
            SizedBox(height: 20.h),
            bodySection()
            // Expanded(
            //   child: GridView.builder(
            //     padding: EdgeInsets.symmetric(vertical: 10.h),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: 0.9,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //     ),
            //     itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return BookCard(
            //         book: filteredSubjects[index % borderColors.length],
            //         backgroundColor:
            //             backgroundColors[index % backgroundColors.length],
            //         borderColor: borderColors[index % borderColors.length],
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder:
            //                   (context) => BookScreen(
            //                     book:
            //                         filteredSubjects[index %
            //                             borderColors.length],
            //                   ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
         
          ],
        ),
      ),
    );
  }

   Widget bodySection() {
    return BlocBuilder<BookAllBloc, BookAllState>(
      builder: (context, state) {
       
        if (state is BookAllSuccessState) {
           List data = state.data.where((book)=>book["subject_id"].toString() == widget.subject.id.toString()).toList();
          if (data.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: SizedBox(
                  height: 80.h,
                  child: Text(
                    "Kitob mavjud emas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            );
          }
          List filterdata = _filterBooks(data);
          return Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filterdata.length,
              itemBuilder: (context, index) {
                print(Endpoints.domain + filterdata[index]["image"].toString());
                Book book = Book(
                  id: filterdata[index]["id"],
                  name: filterdata[index]["name"].toString(),
                  imagePath:
                      Endpoints.domain + filterdata[index]["image"].toString(),
                );
                return     BookCard(
                    book:book,
                    backgroundColor:
                        Color(0xFFFFF0E5),
                    borderColor: Color(0xFFFF9800),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BookScreen(
                                book:
                                    book,
                              ),
                        ),
                      );
                    },
                  );
              
              },
            ),
          );
        } else if (state is BookAllWaitingState) {
          return SizedBox(
            height: 300.h,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppConstant.primaryColor,
                    strokeWidth: 6.w,
                    strokeAlign: 2,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppConstant.primaryColor.withOpacity(0.2),
                  ),
                  SizedBox(height: 48.h),
                  SizedBox(
                    height: 30.h,
                    child: Text(
                      "Ma\'lumot yuklanmoqda...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

}
