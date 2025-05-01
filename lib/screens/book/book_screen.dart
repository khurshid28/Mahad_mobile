import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/section/section_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/section_card.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  final bool stepBlock;
  final bool fullBlock;
  BookScreen({
    required this.book,
    this.fullBlock = false,
    this.stepBlock = true,
  });
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    super.initState();
    SectionController.getAll(context);
  }

  num getPercent(s) {
    var test = s["test"];
    int count = test?["_count"]?["test_items"] ?? 1;
    List results = test?["results"] ?? [];
    if (results.isEmpty) {
      return 0;
    }
    var score = 0;
    for (var r in results) {
      score += (r["solved"] as int);
    }

    return (score * 1000 / (count * results.length)).floor() / 10;
  }

  ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: widget.book.name, isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocListener<SectionAllBloc, SectionAllState>(
            child: SizedBox(),
            listener: (context, state) async {
              if (state is SectionAllErrorState) {
                if (state.statusCode == 401) {
                  Logout(context);
                } else {
                  toastService.error(message: state.message ?? "Xatolik Bor");
                }
              } else if (state is SectionAllSuccessState) {}
            },
          ),

          bodySection(),
        ],
      ),
    );
  }

  Widget bodySection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<SectionAllBloc, SectionAllState>(
        builder: (context, state) {
          if (state is SectionAllSuccessState) {
            final data =
                state.data
                    .where(
                      (s) =>
                          s["book_id"].toString() == widget.book.id.toString(),
                    )
                    .toList();
            if (data.isEmpty) {
              return SizedBox(
                height: 300.h,
                child: Center(
                  child: SizedBox(
                    height: 80.h,
                    child: Text(
                      "Natija mavjud emas",
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

            return Column(
              children: List.generate(data.length, (index) {
                Section section = Section(
                  name: data[index]["name"],
                  id: data[index]["id"],
                  count: data[index]["test"]?["_count"]?["test_items"] ?? 0,
                  percent: getPercent(data[index]),
                  test_id: data[index]["test"]?["id"],
                );

                Section? prev;
                if (index != 0) {
                  prev = Section(
                    name: data[index - 1]["name"],
                    id: data[index - 1]["id"],
                    count:
                        data[index - 1]["test"]?["_count"]?["test_items"] ?? 0,
                    percent: getPercent(data[index - 1]),
                    test_id: data[index - 1]["test"]?["id"],
                  );
                }

                return SectionCard(
                  section: section,
                  block:
                      widget.fullBlock ||
                      (widget.stepBlock &&
                          index != 0 &&
                          (prev?.percent ?? 0) < 60),
                  isFailed: 60 > section.percent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectionScreen(section: section),
                      ),
                    );
                  },
                );

                //   MyResultCard(section: sections[index],result: results[index], onTap: () {
                //        Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => SectionScreen(section: sections[index],),
                //                 ),
                //               );
                //   }),
                // ),
              }),
            );
            // return Expanded(
            //   child: GridView.builder(
            //     padding: EdgeInsets.symmetric(vertical: 10.h),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: 0.9,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //     ),
            //     itemCount: state.data.length,
            //     itemBuilder: (context, index) {
            //       Result res = Result(
            //         solved: state.data[index]["solved"],
            //         date: DateTime.parse(state.data[index]["updatedAt"].toString()),
            //       );
            //       return   MyResultCard(section: sections[index],result: results[index], onTap: () {
            //        Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => SectionScreen(section: sections[index],),
            //                 ),
            //               );
            //     },
            //   );

            //     })
            // );
          } else if (state is SectionAllWaitingState) {
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
                      backgroundColor: AppConstant.primaryColor.withOpacity(
                        0.2,
                      ),
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
      ),
    );
  }
}
