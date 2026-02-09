import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/section/section_all_bloc.dart';
import 'package:test_app/blocs/section/section_all_state.dart';
import 'package:test_app/controller/section_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
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
  const BookScreen({super.key, 
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
    
    // Get the latest result (first in the list since it's ordered by desc)
    var latestResult = results.first;
    int solved = latestResult["solved"] ?? 0;
    
    // Calculate percentage based on latest result
    return ((solved * 100.0) / count).clamp(0, 100).roundToDouble();
  }

  ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: widget.book.name, isLeading: true),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : Colors.grey.shade50,
      body: Column(
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

          Expanded(child: bodySection()),
        ],
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<SectionAllBloc, SectionAllState>(
      builder: (context, state) {
        if (state is SectionAllSuccessState) {
          final data =
              state.data
                  .where(
                    (s) => s["book_id"].toString() == widget.book.id.toString(),
                  )
                  .toList()
                  .reversed
                  .toList();
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.layers_outlined,
                      size: 64.w,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Bo'limlar mavjud emas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Bu kitob uchun bo'limlar qo'shilmagan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: data.length,
            itemBuilder: (context, index) {
              Section section = Section(
                name: data[index]["name"],
                id: data[index]["id"],
                count: data[index]["test"]?["_count"]?["test_items"] ?? 0,
                percent: getPercent(data[index]),
                test_id: data[index]["test"]?["id"].toString(),
              );

              Section? prev;
              if (index != 0) {
                prev = Section(
                  name: data[index - 1]["name"],
                  id: data[index - 1]["id"],
                  count: data[index - 1]["test"]?["_count"]?["test_items"] ?? 0,
                  percent: getPercent(data[index - 1]),
                  test_id: data[index - 1]["test"]?["id"].toString(),
                );
              }

              bool isBlocked =
                  widget.fullBlock ||
                  (widget.stepBlock && index != 0 && (prev?.percent ?? 0) < widget.book.passingPercentage);

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SectionCard(
                  section: section,
                  block: isBlocked,
                  isFailed: widget.book.passingPercentage > section.percent,
                  onTap: () {
                    if (isBlocked) {
                      // Show message why it's blocked
                      toastService.error(
                        message: widget.fullBlock
                            ? "Bu kitob to'liq qulflangan"
                            : "Oldingi bo'limni kamida ${widget.book.passingPercentage}% natija bilan tugatishingiz kerak",
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectionScreen(section: section),
                      ),
                    );
                  },
                ),
              );
            },
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
          return Center(
            child: CommonLoading(message: "Ma'lumot yuklanmoqda..."),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
