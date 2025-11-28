import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/result/result_all_bloc.dart';
import 'package:test_app/blocs/result/result_all_state.dart';
import 'package:test_app/controller/result_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/section/section_screen.dart';
import 'package:test_app/screens/test/finished_test_screen.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/my_result_card.dart';
import 'package:test_app/widgets/my_result_random_card.dart';

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
                Result res = Result(
                  solved: state.data[index]["solved"],
                  
                  date: DateTime.parse(
                    state.data[index]["updatedAt"].toString(),
                  ),
                  test: state.data[index]["test"],
                  type: state.data[index]["type"]
                );
               
                
                // print(">>>>");
                // print( state.data[index]);

               
                if (res.type == "RANDOM") {
                    Section section = Section(
                  name: "RANDOM",
                  id: 0,
                  count: 0,
                  test_id: null
                );
                  return MyResultRandomCard(
                  result: res,
                  count : (state.data[index]["answers"] ??  []).length,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                FinishedTestScreen(section: section,answers: state.data[index]["answers"] ??  [],),
                      ),
                    );
                  },
                );
                }else{

               
               
                  Section section = Section(
                  name: res.test?["section"]?["name"],
                  id:  res.test?["section"]?["id"],
                  count: res.test?["_count"]?["test_items"] ?? 1,
                  test_id: res.test["id"].toString()
                );
                  return MyResultCard(
                  result: res,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                SectionScreen(section: section),
                      ),
                    );
                  },
                );
                }

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
