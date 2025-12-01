import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_all_bloc.dart';
import 'package:test_app/blocs/result/result_all_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/screens/my_result/result_detail_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/my_result_card.dart';
import 'package:test_app/widgets/my_result_random_card.dart';
import 'package:test_app/widgets/my_result_special_test_card.dart';

class MyResultScreen extends StatefulWidget {
  @override
  _MyResultScreenState createState() => _MyResultScreenState();
}

class _MyResultScreenState extends State<MyResultScreen> {
 

  @override
  void initState() {
    super.initState();
    ResultController.getAll(context);
  }

ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: "Mening natijalarim", isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             BlocListener<ResultAllBloc, ResultAllState>(
                child: SizedBox(),
                listener: (context, state) async {
                  if (state is ResultAllErrorState) {
                    if (state.statusCode == 401) {
                      Logout(context);
                    } else {
                      toastService.error(message: state.message ?? "Xatolik Bor");
                    }
                  } else if (state is ResultAllSuccessState) {}
                },
              ),
            bodySection(),
          ],
        ),
      ),
    );
  }

  Widget bodySection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<ResultAllBloc, ResultAllState>(
        builder: (context, state) {
          if (state is ResultAllSuccessState) {
            if (state.data.isEmpty) {
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
              children: List.generate(state.data.length, (index) {
                final resultData = state.data[index];
                
                // Convert answers to List if needed
                List<dynamic>? answersList;
                if (resultData["answers"] != null) {
                  if (resultData["answers"] is List) {
                    answersList = resultData["answers"] as List<dynamic>;
                  } else if (resultData["answers"] is Map) {
                    // If it's a Map, convert values to list
                    answersList = (resultData["answers"] as Map).values.toList();
                  }
                }
                
                Result res = Result(
                  solved: resultData["solved"] ?? 0,
                  date: DateTime.parse(resultData["updatedAt"].toString()).add(const Duration(hours: 5)),
                  test: resultData["test"],
                  type: resultData["type"],
                  answers: answersList,
                );
               
                // RANDOM test
                if (res.type == "RANDOM") {
                  final count = answersList?.length ?? 0;
                  return MyResultRandomCard(
                    result: res,
                    count: count,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultDetailScreen(
                            result: res,
                            totalQuestions: count,
                            testName: "Aralash Test",
                            subjectName: null,
                            bookName: null,
                          ),
                        ),
                      );
                    },
                  );
                }
                
                // SpecialTest
                else if (res.type == "SpecialTest" && resultData["specialTest"] != null) {
                  final specialTest = resultData["specialTest"];
                  final questionCount = specialTest["question_count"] ?? 0;
                  return MyResultSpecialTestCard(
                    result: res,
                    specialTest: specialTest,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultDetailScreen(
                            result: res,
                            totalQuestions: questionCount,
                            testName: specialTest["name"] ?? "Maxsus Test",
                            subjectName: null,
                            bookName: null,
                          ),
                        ),
                      );
                    },
                  );
                }
                
                // Book test (oddiy test)
                else if (res.test != null) {
                  final testCount = res.test?["_count"]?["test_items"] ?? 1;
                  final subjectName = res.test?["section"]?["book"]?["subject"]?["name"];
                  final bookName = res.test?["section"]?["book"]?["name"];
                  final sectionName = res.test?["section"]?["name"];
                  
                  return MyResultCard(
                    result: res,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultDetailScreen(
                            result: res,
                            totalQuestions: testCount,
                            testName: sectionName ?? "Test",
                            subjectName: subjectName,
                            bookName: bookName,
                          ),
                        ),
                      );
                    },
                  );
                }
                
                // Fallback - agar hech narsa mos kelmasa
                return SizedBox.shrink();
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
          } else if (state is ResultAllWaitingState) {
            return SizedBox(
              height: 300.h,
              child: CommonLoading(
                message: "Ma\'lumot yuklanmoqda...",
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
