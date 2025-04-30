import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/rate/rate_state.dart';
import 'package:test_app/controller/rate_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/rate.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/rate_card.dart';

class RateScreen extends StatefulWidget {
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  // List<Rate> rates = [
  //   Rate(name: "Ismoilov Xurshid", rate: 1,try_count: 4,avg: 81.7,imagePath:"assets/images/profile.jpg" ),
  //   Rate(name: "Davlatov MuhammadUmar", rate: 2,try_count: 2,avg: 68.4,imagePath:"assets/images/profile.jpg" ),
  //   Rate(name: "Bahodirov Alisher", rate: 3,try_count: 8,avg: 35,imagePath:"assets/images/profile.jpg" ),
  //   Rate(name: "Shermat Aliyev", rate: 4,try_count: 2,avg: 22.5,imagePath:"assets/images/profile.jpg" ),
  //   Rate(name: "Elbek Ergashov", rate: 5,try_count: 0,avg: 0,imagePath:"assets/images/profile.jpg" ),
  //   Rate(name: "Shaxriyor G'ulomov", rate: 6,try_count: 0,avg: 0,imagePath:"assets/images/profile.jpg" ),

  // ];

  num getPercent(List results) {
    double score = 0;
    if (results.isEmpty) {
      return 0;
    }
    for (var r in results) {
      score +=
          (r["solved"] as int) / (r["test"]?["_count"]?["test_items"] ?? 1);
    }

    return (score * 1000 / (results.length)).floor() / 10;
  }

  List sortRates(List data) {
    data.sort(
      (a, b) => getPercent(b["results"]).compareTo(getPercent(a["results"])),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    RateController.getAll(context);
  }

  ToastService toastService = ToastService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: "Liderlar", isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<RateBloc, RateState>(
              child: SizedBox(),
              listener: (context, state) async {
                if (state is RateErrorState) {
                  if (state.statusCode == 401) {
                    Logout(context);
                  } else {
                    toastService.error(message: state.message ?? "Xatolik Bor");
                  }
                } else if (state is RateSuccessState) {
                  sortRates(state.data);
                }
              },
            ),
        
            bodySection(),
          ],
        ),
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<RateBloc, RateState>(
      builder: (context, state) {
        if (state is RateSuccessState) {
          if (state.data.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: SizedBox(
                  height: 80.h,
                  child: Text(
                    "Rating mavjud emas",
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

          final data = sortRates(state.data);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              children: List.generate(
                data.length,
                (index) => RateCard(
                  rate: Rate(
                    avg: getPercent(data[index]["results"]),
                    try_count: (data[index]["results"] as List).length,
                    name: data[index]["name"].toString(),
                    index: index,
                    id: data[index]["id"],
                  ),
                  onTap: () {},
                ),
              ),
            ),
          );
        } else if (state is RateWaitingState) {
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
        }

        return SizedBox();
      },
    );
  }
}
