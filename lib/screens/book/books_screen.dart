import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/book/book_all_bloc.dart';
import 'package:test_app/blocs/book/book_all_state.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/controller/book_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/core/endpoints/endpoints.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/screens/test/random_test_screen.dart';
import 'package:test_app/screens/test/random_test_screen_notime.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:uuid/uuid.dart';

import '../../models/section.dart';

class BooksScreen extends StatefulWidget {
  final Subject subject;
  const BooksScreen({super.key, required this.subject});
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
    for (var e in selectedItems) {
      e["items"].forEach((item) {
        if (item["selected"]) {
          count += ((item["answers"] ?? []) as List).length;
        }
      });
    }
    return count;
  }

  List<int> selecteds() {
    List<int> res = [];
    for (var e in selectedItems) {
      e["items"].forEach((item) {
        if (item["selected"]) {
          res.add(item["id"]);
        }
      });
    }
    return res;
  }

  bool hasTime() {
    Map? user = StorageService().read(StorageService.user);
    return user?["group"]?["hasTime"] ?? false;
  }

  // Timer sozlamalari dialogini ko'rsatish
  Future<Map<String, dynamic>?> _showTimerSettingsDialog() async {
    int? selectedOption =
        0; // 0: Timer yo'q, 1: Umumiy vaqt, 2: Har savol uchun
    int fullTimeMinutes = 30;
    int timePerQuestionSeconds = 60;
    bool forceNextQuestion = false;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppConstant.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.timer,
                      color: AppConstant.primaryColor,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Timer sozlamalari',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timer yo'q
                    RadioListTile<int>(
                      title: Text('Timer yo\'q'),
                      value: 0,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    // Umumiy vaqt
                    RadioListTile<int>(
                      title: Text('Umumiy test uchun vaqt'),
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    if (selectedOption == 1)
                      Padding(
                        padding: EdgeInsets.only(left: 32.w, top: 8.h),
                        child: Row(
                          children: [
                            Text('Vaqt: '),
                            SizedBox(
                              width: 70.w,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '30',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  fullTimeMinutes = int.tryParse(value) ?? 30;
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text('minut'),
                          ],
                        ),
                      ),
                    // Har savol uchun
                    RadioListTile<int>(
                      title: Text('Har bir savol uchun vaqt'),
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    if (selectedOption == 2)
                      Padding(
                        padding: EdgeInsets.only(left: 32.w, top: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Vaqt: '),
                                SizedBox(
                                  width: 70.w,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '60',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      timePerQuestionSeconds =
                                          int.tryParse(value) ?? 60;
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text('sekund/savol'),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Keyingi savolga o\'tish majburiy',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: forceNextQuestion,
                                  onChanged: (value) {
                                    setState(() {
                                      forceNextQuestion = value;
                                    });
                                  },
                                  activeColor: AppConstant.primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, null),
                  child: Text(
                    'Bekor qilish',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstant.primaryColor,
                        AppConstant.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> result = {
                        'useTimer': selectedOption != 0,
                        'fullTime':
                            selectedOption == 1 ? fullTimeMinutes : null,
                        'timePerQuestion':
                            selectedOption == 2 ? timePerQuestionSeconds : null,
                        'forceNextQuestion':
                            selectedOption == 2 ? forceNextQuestion : false,
                      };
                      Navigator.pop(dialogContext, result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      'Davom etish',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : Colors.grey.shade50,
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
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder:
                            (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: BlocBuilder<
                                SectionAllBloc,
                                SectionAllState
                              >(
                                builder: (context, stateSectionAll) {
                                  if (stateSectionAll
                                      is SectionAllSuccessState) {
                                    var sections = stateSectionAll.data;
                                    return StatefulBuilder(
                                      builder: (context, sts) {
                                        return Container(
                                          height: 0.9.sh,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.r),
                                              topRight: Radius.circular(30.r),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 20.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppConstant.primaryColor,
                                                      AppConstant.primaryColor
                                                          .withOpacity(0.8),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                              30.r,
                                                            ),
                                                        topRight:
                                                            Radius.circular(
                                                              30.r,
                                                            ),
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Kitoblar va bo'limlar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          8.w,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                            ),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 20.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 16.h,
                                                  ),
                                                  child: Column(
                                                    children: [
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
                                                              sortedSections.map((
                                                                e,
                                                              ) {
                                                                e["selected"] =
                                                                    false;
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
                                                                          .map((
                                                                            e,
                                                                          ) {
                                                                            e["selected"] =
                                                                                !value;

                                                                            return e;
                                                                          })
                                                                          .toList();
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 34.w,
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
                                                                      gradient:
                                                                          selectedItems[index]["selected"]
                                                                              ? LinearGradient(
                                                                                colors: [
                                                                                  AppConstant.primaryColor,
                                                                                  AppConstant.primaryColor.withOpacity(
                                                                                    0.8,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                              : null,
                                                                      border:
                                                                          !selectedItems[index]["selected"]
                                                                              ? Border.all(
                                                                                color:
                                                                                    Colors.grey.shade400,
                                                                                width:
                                                                                    2.w,
                                                                              )
                                                                              : null,
                                                                      boxShadow:
                                                                          selectedItems[index]["selected"]
                                                                              ? [
                                                                                BoxShadow(
                                                                                  color: AppConstant.primaryColor.withOpacity(
                                                                                    0.3,
                                                                                  ),
                                                                                  blurRadius:
                                                                                      8,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    3,
                                                                                  ),
                                                                                ),
                                                                              ]
                                                                              : null,
                                                                    ),
                                                                    child:
                                                                        selectedItems[index]["selected"]
                                                                            ? Icon(
                                                                              Icons.check_rounded,
                                                                              color:
                                                                                  Colors.white,
                                                                              size:
                                                                                  20.sp,
                                                                            )
                                                                            : null,
                                                                  ),

                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        260.w,
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
                                                                sortedSections
                                                                    .length,
                                                                (i) => Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16.w,
                                                                    vertical:
                                                                        4.h,
                                                                  ),
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      selectedItems[index]["items"][i]["selected"] =
                                                                          !selectedItems[index]["items"][i]["selected"];
                                                                      sts(
                                                                        () {},
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              34.w,
                                                                          height:
                                                                              34.w,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                              12.r,
                                                                            ),
                                                                            gradient:
                                                                                selectedItems[index]["items"][i]["selected"]
                                                                                    ? LinearGradient(
                                                                                      colors: [
                                                                                        AppConstant.accentOrange,
                                                                                        AppConstant.accentOrange.withOpacity(
                                                                                          0.8,
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                    : null,
                                                                            border:
                                                                                !selectedItems[index]["items"][i]["selected"]
                                                                                    ? Border.all(
                                                                                      color:
                                                                                          Colors.grey.shade400,
                                                                                      width:
                                                                                          2.w,
                                                                                    )
                                                                                    : null,
                                                                            boxShadow:
                                                                                selectedItems[index]["items"][i]["selected"]
                                                                                    ? [
                                                                                      BoxShadow(
                                                                                        color: AppConstant.accentOrange.withOpacity(
                                                                                          0.3,
                                                                                        ),
                                                                                        blurRadius:
                                                                                            8,
                                                                                        offset: Offset(
                                                                                          0,
                                                                                          3,
                                                                                        ),
                                                                                      ),
                                                                                    ]
                                                                                    : null,
                                                                          ),
                                                                          child:
                                                                              selectedItems[index]["items"][i]["selected"]
                                                                                  ? Icon(
                                                                                    Icons.check_rounded,
                                                                                    color:
                                                                                        Colors.white,
                                                                                    size:
                                                                                        20.sp,
                                                                                  )
                                                                                  : null,
                                                                        ),

                                                                        SizedBox(
                                                                          width:
                                                                              10.w,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              244.w,
                                                                          child: Text(
                                                                            selectedItems[index]["items"][i]["name"].toString(),
                                                                            style:
                                                                                TextStyle(),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            SizedBox(
                                                              height: 16.h,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                      SizedBox(height: 24.h),
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          20.w,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16.r,
                                                              ),
                                                          border: Border.all(
                                                            color: AppConstant
                                                                .primaryColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            width: 2,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppConstant
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                0,
                                                                4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    12.w,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    AppConstant
                                                                        .primaryColor,
                                                                    AppConstant
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                          0.8,
                                                                        ),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12.r,
                                                                    ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .format_list_numbered_rounded,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                size: 24.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 16.w,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Test soni",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color:
                                                                          Colors
                                                                              .grey
                                                                              .shade600,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12.w,
                                                                      vertical:
                                                                          8.h,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color: AppConstant
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                            0.05,
                                                                          ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                      border: Border.all(
                                                                        color: AppConstant
                                                                            .primaryColor
                                                                            .withOpacity(
                                                                              0.2,
                                                                            ),
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    child: TextFormField(
                                                                      controller:
                                                                          numberOfTestController,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      cursorColor:
                                                                          AppConstant
                                                                              .primaryColor,
                                                                      onChanged:
                                                                          (
                                                                            value,
                                                                          ) => sts(
                                                                            () {},
                                                                          ),
                                                                      style: TextStyle(
                                                                        color:
                                                                            AppConstant.primaryColor,
                                                                        fontSize:
                                                                            20.sp,
                                                                        fontWeight:
                                                                            FontWeight.w900,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText:
                                                                            '20',
                                                                        hintStyle: TextStyle(
                                                                          color: AppConstant.primaryColor.withOpacity(
                                                                            0.3,
                                                                          ),
                                                                          fontSize:
                                                                              20.sp,
                                                                          fontWeight:
                                                                              FontWeight.w900,
                                                                        ),
                                                                        border:
                                                                            InputBorder.none,
                                                                        enabledBorder:
                                                                            InputBorder.none,
                                                                        focusedBorder:
                                                                            InputBorder.none,
                                                                        contentPadding:
                                                                            EdgeInsets.zero,
                                                                        isDense:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16.r,
                                                              ),
                                                          gradient:
                                                              (checkTestBoshlash())
                                                                  ? LinearGradient(
                                                                    colors: [
                                                                      AppConstant
                                                                          .primaryColor,
                                                                      AppConstant
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                            0.8,
                                                                          ),
                                                                    ],
                                                                  )
                                                                  : null,
                                                          color:
                                                              (checkTestBoshlash())
                                                                  ? null
                                                                  : Colors
                                                                      .grey
                                                                      .shade300,
                                                          boxShadow:
                                                              (checkTestBoshlash())
                                                                  ? [
                                                                    BoxShadow(
                                                                      color: AppConstant
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                            0.4,
                                                                          ),
                                                                      blurRadius:
                                                                          12,
                                                                      offset:
                                                                          Offset(
                                                                            0,
                                                                            6,
                                                                          ),
                                                                    ),
                                                                  ]
                                                                  : null,
                                                        ),
                                                        child: Material(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              // var login = "+998${phoneController.text.replaceAll(" ", "")}";
                                                              // var password = passwordController.text;
                                                              // if (login.length == 13 && password.length >= 8) {
                                                              //   await AuthController.login(context, login: login, password: password);
                                                              // }
                                                              if (checkTestBoshlash()) {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                final uuid =
                                                                    Uuid();

                                                                // Random test uchun timer sozlamalarini tanlash
                                                                final timerSettings =
                                                                    await _showTimerSettingsDialog();

                                                                if (timerSettings ==
                                                                    null) {
                                                                  // User bekor qildi
                                                                  return;
                                                                }

                                                                await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => RandomTestScreen(
                                                                          sections:
                                                                              selecteds(),
                                                                          count: int.parse(
                                                                            numberOfTestController.text,
                                                                          ),
                                                                          section: Section(
                                                                            name:
                                                                                "Random",
                                                                            count:
                                                                                0,
                                                                            test_id:
                                                                                uuid.v4(),
                                                                          ),
                                                                          useTimer:
                                                                              timerSettings['useTimer'],
                                                                          customFullTime:
                                                                              timerSettings['fullTime'],
                                                                          customTimePerQuestion:
                                                                              timerSettings['timePerQuestion'],
                                                                          forceNextQuestion:
                                                                              timerSettings['forceNextQuestion'] ??
                                                                              false,
                                                                        ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16.r,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    vertical:
                                                                        16.h,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .play_arrow_rounded,
                                                                    color:
                                                                        (checkTestBoshlash())
                                                                            ? Colors.white
                                                                            : Colors.grey.shade500,
                                                                    size: 24.sp,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.w,
                                                                  ),
                                                                  Text(
                                                                    "Testni boshlash",
                                                                    style: TextStyle(
                                                                      color:
                                                                          (checkTestBoshlash())
                                                                              ? Colors.white
                                                                              : Colors.grey.shade500,
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 32.h),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                cursorColor: AppConstant.primaryColor,
                onChanged: (e) => setState(() {}),
                controller: seachController,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Kitoblarni qidirish...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppConstant.primaryColor,
                    size: 22.w,
                  ),
                  suffixIcon:
                      seachController.text.isNotEmpty
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
                      "Bu fan uchun kitoblar qo'shilmagan",
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
          List filterdata = _filterBooks(data);

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
                return BookCard(
                  book: book,
                  backgroundColor: AppConstant.primaryColor.withOpacity(0.05),
                  borderColor: AppConstant.primaryColor,
                  isBlocked: filterdata[index]["fullBlock"] ?? false,
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
            child: CommonLoading(message: "Ma'lumot yuklanmoqda..."),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
