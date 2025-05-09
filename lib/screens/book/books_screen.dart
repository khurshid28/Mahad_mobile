import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/blocs/subject/subject_all_bloc.dart';
import 'package:test_app/blocs/subject/subject_all_state.dart';
import 'package:test_app/controller/book_controller.dart';
import 'package:test_app/controller/test_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/screens/test/random_test_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:uuid/uuid.dart';

import '../../models/section.dart';

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
    return books
        .where(
          (book) => book["name"].toLowerCase().contains(
            seachController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  ToastService toastService = ToastService();
  TextEditingController seachController = TextEditingController();
  List selectedItems = [];

  TextEditingController numberOfTestController = TextEditingController(
    text: "20",
  );

  InputDecoration inputDecoration({
    required String labelText,
    required String hintText,
    required String iconPath,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.all(12.w),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(AppConstant.greyColor, BlendMode.srcIn),
        ),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.greyColor, width: 3.w),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.greyColor, width: 3.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.greyColor, width: 3.w),
      ),
      labelStyle: TextStyle(color: AppConstant.blackColor, fontSize: 16.sp),
      hintText: hintText,
      hintStyle: TextStyle(color: AppConstant.greyColor, fontSize: 16.sp),
      errorStyle: TextStyle(
        color: AppConstant.redColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  bool checkTestBoshlash() {
    return selectedItems.any(
          (e) => (e["items"] as List).any((item) => item["selected"]),
        ) &&
        numberOfTestController.text.isNotEmpty &&
        int.tryParse(numberOfTestController.text) != null;
  }

  int countAll() {
    int count = 0;
    selectedItems.forEach((e) {
      e["items"].forEach((item) {
        if (item["selected"]) {
          count += ((item["answers"] ?? []) as List).length;
        }
      });
    });
    return count;
  }

  List<int> selecteds() {
    List<int> res = [];
    selectedItems.forEach((e) {
      e["items"].forEach((item) {
        if (item["selected"]) {
          res.add(item["id"]);
        }
      });
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          titleText: widget.subject.name,
          isLeading: true,
          actions: [
            BlocBuilder<BookAllBloc, BookAllState>(
              builder: (context, state) {
                if (state is BookAllSuccessState) {
                  List data =
                      state.data
                          .where(
                            (book) =>
                                book["subject_id"].toString() ==
                                widget.subject.id.toString(),
                          )
                          .toList();
                  selectedItems =
                      data.map((e) {
                        e["items"] = [];
                        e["selected"] = false;
                        return e;
                      }).toList();

                  return GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        
                        showDragHandle: true,
                        context: context,
                        builder:
                            (
                              context,
                            ) =>  
                                 Padding(
                                 padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Push up on keyboard
          ),
                                  child: BlocBuilder<SectionAllBloc, SectionAllState>(
                                    builder: (context, stateSectionAll) {
                                      if (stateSectionAll is SectionAllSuccessState) {
                                        var sections = stateSectionAll.data;
                                        return StatefulBuilder(
                                          builder: (context, sts) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.9,
                                              widthFactor: 1,
                                              child: SingleChildScrollView(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 16.h,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Kitoblar va bo'limlar",
                                                          style: TextStyle(
                                                            color:
                                                                AppConstant
                                                                    .blackColor,
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16.h),
                                                    ...List.generate(selectedItems.length, (
                                                      index,
                                                    ) {
                                                      var sortedSections =
                                                          sections
                                                              .where(
                                                                (e) =>
                                                                    e["book_id"]
                                                                        .toString() ==
                                                                    data[index]["id"]
                                                                        .toString(),
                                                              )
                                                              .toList();
                                  
                                                      if ((selectedItems[index]["items"]
                                                              as List)
                                                          .isEmpty) {
                                                        selectedItems[index]["items"] =
                                                            sortedSections.map((e) {
                                                              e["selected"] = false;
                                                              return e;
                                                            }).toList();
                                                      }
                                  
                                                      return Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              sts(() {
                                                                var value =
                                                                    selectedItems[index]["selected"];
                                                                selectedItems[index]["selected"] =
                                                                    !value;
                                  
                                                                selectedItems[index]["items"] =
                                                                    (selectedItems[index]["items"]
                                                                            as List)
                                                                        .map((e) {
                                                                          e["selected"] =
                                                                              !value;
                                  
                                                                          return e;
                                                                        })
                                                                        .toList();
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                selectedItems[index]["selected"]
                                                                    ? Container(
                                                                      width: 34.w,
                                                                      height: 34.w,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12.r,
                                                                            ),
                                                                        color:
                                                                            AppConstant
                                                                                .primaryColor,
                                                                      ),
                                                                      child: SvgPicture.asset(
                                                                        'assets/icons/check.svg',
                                                                        width: 18.w,
                                                                        colorFilter: const ColorFilter.mode(
                                                                          AppConstant
                                                                              .whiteColor,
                                                                          BlendMode
                                                                              .srcIn,
                                                                        ),
                                                                      ),
                                                                    )
                                                                    : Container(
                                                                      width: 34.w,
                                                                      height: 34.w,
                                  
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12.r,
                                                                            ),
                                                                        border: Border.all(
                                                                          color:
                                                                              Colors
                                                                                  .grey
                                                                                  .shade500,
                                                                          width: 3.w,
                                                                        ),
                                                                      ),
                                                                    ),
                                  
                                                                SizedBox(width: 10.w),
                                                                SizedBox(
                                                                  width: 260.w,
                                                                  child: Text(
                                                                    data[index]["name"]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (selectedItems[index]["selected"])
                                                            ...List.generate(
                                                              sortedSections.length,
                                                              (i) => Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16.w,
                                                                      vertical: 4.h,
                                                                    ),
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    selectedItems[index]["items"][i]["selected"] =
                                                                        !selectedItems[index]["items"][i]["selected"];
                                                                    sts(() {});
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      selectedItems[index]["items"][i]["selected"]
                                                                          ? Container(
                                                                            width:
                                                                                34.w,
                                                                            height:
                                                                                34.w,
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                    12.r,
                                                                                  ),
                                                                              color:
                                                                                  AppConstant.primaryColor,
                                                                            ),
                                                                            child: SvgPicture.asset(
                                                                              'assets/icons/check.svg',
                                                                              width:
                                                                                  18.w,
                                                                              colorFilter: const ColorFilter.mode(
                                                                                AppConstant
                                                                                    .whiteColor,
                                                                                BlendMode
                                                                                    .srcIn,
                                                                              ),
                                                                            ),
                                                                          )
                                                                          : Container(
                                                                            width:
                                                                                34.w,
                                                                            height:
                                                                                34.w,
                                  
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                    12.r,
                                                                                  ),
                                                                              border: Border.all(
                                                                                color:
                                                                                    Colors.grey.shade500,
                                                                                width:
                                                                                    3.w,
                                                                              ),
                                                                            ),
                                                                          ),
                                  
                                                                      SizedBox(
                                                                        width: 10.w,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 244.w,
                                                                        child: Text(
                                                                          selectedItems[index]["items"][i]["name"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          SizedBox(height: 16.h),
                                                        
                                                         ],
                                                      );
                                                    }),
                                                        Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 108.w,
                                                                child: TextFormField(
                                                                  controller:
                                                                      numberOfTestController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  cursorColor:
                                                                      AppConstant
                                                                          .blackColor,
                                                                  onChanged:
                                                                      (value) =>
                                                                          sts(
                                                                            () {},
                                                                          ),
                                                                  decoration:
                                                                      inputDecoration(
                                                                        labelText: "",
                                                                        hintText: '',
                                                                        iconPath:
                                                                            'assets/icons/magazine.svg',
                                                                      ),
                                                                  style: TextStyle(
                                                                    color:
                                                                        AppConstant
                                                                            .blackColor,
                                                                    fontSize: 16.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 16.h),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  (checkTestBoshlash())
                                                                      ? AppConstant
                                                                          .primaryColor
                                                                      : AppConstant
                                                                          .greyColor,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.r,
                                                                    ),
                                                              ),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    vertical: 14.h,
                                                                  ),
                                                            ),
                                                            onPressed: () async {
                                                              // var login = "+998${phoneController.text.replaceAll(" ", "")}";
                                                              // var password = passwordController.text;
                                                              // if (login.length == 13 && password.length >= 8) {
                                                              //   await AuthController.login(context, login: login, password: password);
                                                              // }
                                                              if (checkTestBoshlash()) {
                                                                // var count =
                                                                //     countAll();
                                                                // if (int.parse(
                                                                //       numberOfTestController
                                                                //           .text,
                                                                //     ) <=
                                                                //     count) {
                                                                Navigator.pop(context);
                                                                  final uuid = Uuid();
                                                                  
                                                                  await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) => RandomTestScreen(
                                                                            sections:
                                                                                selecteds(),
                                                                            count:
                                                                                int.parse(numberOfTestController.text),
                                                                            section: Section(
                                                                              name:
                                                                                  "Random",
                                                                              count:
                                                                                  0,
                                                                              test_id:
                                                                                  uuid.v4(),
                                                                            ),
                                                                          ),
                                                                    ),
                                                                  );
                                                                // } else {
                                                                //   toastService.error(
                                                                //     message:
                                                                //         "Jami test $count ta ",
                                                                //   );
                                                                // }
                                                              }
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                "Testni boshlash",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                           SizedBox(height: 16.h),
                                                     
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                )
                           ,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20.w),

                        SvgPicture.asset(
                          "assets/icons/magazine.svg",
                          height: 30.h,
                          color: AppConstant.primaryColor,
                        ),
                        SizedBox(width: 20.w),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
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
            bodySection(),

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
          List data =
              state.data
                  .where(
                    (book) =>
                        book["subject_id"].toString() ==
                        widget.subject.id.toString(),
                  )
                  .toList();
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
                return BookCard(
                  book: book,
                  backgroundColor: Color(0xFFFFF0E5),
                  borderColor: Color(0xFFFF9800),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BookScreen(
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
