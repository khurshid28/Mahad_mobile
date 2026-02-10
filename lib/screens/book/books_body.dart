

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/controller/book_controller.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/BookCard.dart';

class BooksBody extends StatefulWidget {
  const BooksBody({super.key});

  @override
  _BooksBodyState createState() => _BooksBodyState();
}

class _BooksBodyState extends State<BooksBody> {
  ToastService toastService = ToastService();
  
  // final List<Book> books = [
  //   Book(name: "Germaniya tarixi", imagePath: "assets/images/history.png"),
  //   Book(name: "Angliya tarixi", imagePath: "assets/images/adabiyot.png"),
  //   Book(name: "O'rta Osiyo tarixi", imagePath: "assets/images/matematika.png"),
  //    Book(name: "Fransiya tarixi", imagePath: "assets/images/matematika.png"),
  // ];

  // final List<Color> backgroundColors = [
  //   Color(0xFFEAF8E5), // Yashil fon
  //   Color(0xFFFFF0E5), // Apelsin fon
  //   Color(0xFFFFE5E5), // Qizil fon

  //    Color.fromARGB(255, 204, 203, 246),
  // ];

  // final List<Color> borderColors = [
  //   Color(0xFF4CAF50), // Yashil ramka (Tarix)
  //   Color(0xFFFF9800), // Apelsin ramka (Adabiyot)
  //   Color(0xFFF44336), // Qizil ramka (Matematika)
  //    Color.fromARGB(255, 124, 118, 240),
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


  TextEditingController seachController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                cursorColor: AppConstant.primaryColor,
                onChanged: (e) => setState(() {}),
                controller: seachController,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Kitoblarni qidirish...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 12.w),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppConstant.primaryColor,
                      size: 22.w,
                    ),
                  ),
                  suffixIcon: seachController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.grey.shade400,
                            size: 20.w,
                          ),
                          onPressed: () {
                            setState(() {
                              seachController.clear();
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppConstant.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 20),
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
            //         book: filteredbooks[index%borderColors.length],
            //         backgroundColor: backgroundColors[index % backgroundColors.length],
            //         borderColor: borderColors[index % borderColors.length],
            //         onTap: () {
            //            Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => BookScreen(book: filteredbooks[index%borderColors.length],),
            //               ),
            //             );
            //         },
            //       );
            //     },
            //   ),
            // ),
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
          ],
        ),
      ),
    );
  }

   Widget bodySection() {
    return BlocBuilder<BookAllBloc, BookAllState>(
      builder: (context, state) {
       
        if (state is BookAllSuccessState) {
          if (state.data.isEmpty) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 80.w,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Kitoblar mavjud emas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Hozircha hech qanday kitob qo'shilmagan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          List filterdata = _filterBooks(state.data);
          
          if (filterdata.isEmpty) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64.w,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Kitob topilmadi",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Boshqa nom bilan qidiring",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: filterdata.length,
              itemBuilder: (context, index) {
                print(Endpoints.domain + filterdata[index]["image"].toString());
                Book book = Book(
                  id: filterdata[index]["id"],
                  name: filterdata[index]["name"].toString(),
                  imagePath:
                      Endpoints.domain + filterdata[index]["image"].toString(),
                  passingPercentage: filterdata[index]["passingPercentage"] ?? 60,
                  fullBlock: filterdata[index]["fullBlock"] ?? false,
                  stepBlock: filterdata[index]["stepBlock"] ?? false,
                );
                bool isBookBlocked = filterdata[index]["fullBlock"] ?? false;
                return BookCard(
                  book: book,
                  backgroundColor: AppConstant.primaryColor.withOpacity(0.05),
                  borderColor: AppConstant.primaryColor,
                  isBlocked: isBookBlocked,
                  onTap: () {
                    // Navigate to book screen - if blocked, will show locked message inside
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookScreen(
                          book: book,
                          fullBlock: filterdata[index]["fullBlock"],
                          stepBlock: filterdata[index]["stepBlock"],
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
            child: CommonLoading(
              message: "Ma'lumot yuklanmoqda...",
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

}

