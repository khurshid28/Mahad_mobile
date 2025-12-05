import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/rate/rate_bloc.dart';
import 'package:test_app/blocs/rate/rate_state.dart';
import 'package:test_app/controller/rate_controller.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/rate.dart';
import 'package:test_app/service/logout.dart';
import 'package:test_app/service/toast_service.dart';
import 'package:test_app/widgets/rate_card.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

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
    int totalTests = 0;

    if (results.isEmpty) {
      return 0;
    }

    for (var r in results) {
      try {
        if (r["type"] == "RANDOM") {
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = ((r["answers"] ?? []) as List).length;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        } else if (r["type"] == "SPECIAL") {
          // Maxsus testlar
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = ((r["answers"] ?? []) as List).length;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        } else {
          // Oddiy testlar
          int solved = (r["solved"] ?? 0) as int;
          int totalItems = r["test"]?["_count"]?["test_items"] ?? 1;
          if (totalItems > 0) {
            score += solved / totalItems;
            totalTests++;
          }
        }
      } catch (e) {
        print("❌ Error calculating percent: $e");
      }
    }

    if (totalTests == 0) return 0;
    return (score * 1000 / totalTests).floor() / 10;
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
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: AppConstant.primaryColor,
            leading: Center(
              child: IconButton(
                icon: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Liderlar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstant.primaryColor,
                      AppConstant.primaryColor.withOpacity(0.8),
                      AppConstant.accentOrange.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50.w,
                      top: -50.h,
                      child: Icon(
                        Icons.emoji_events,
                        size: 200.sp,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: -30.w,
                      bottom: -30.h,
                      child: Icon(
                        Icons.star,
                        size: 150.sp,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                BlocListener<RateBloc, RateState>(
                  child: SizedBox(),
                  listener: (context, state) async {
                    if (state is RateErrorState) {
                      if (state.statusCode == 401) {
                        Logout(context);
                      } else {
                        toastService.error(
                          message: state.message ?? "Xatolik Bor",
                        );
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
        ],
      ),
    );
  }

  Widget bodySection() {
    return BlocBuilder<RateBloc, RateState>(
      builder: (context, state) {
        if (state is RateSuccessState) {
          if (state.data.isEmpty) {
            return Container(
              height: 400.h,
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppConstant.accentOrange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events_outlined,
                        size: 60.sp,
                        color: AppConstant.accentOrange,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Rating mavjud emas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        "Hozircha liderlar ro'yxati bo'sh",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = sortRates(state.data);

          return Column(
            children: [
              // Liderlar ro'yxati
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
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
              ),
            ],
          );
        } else if (state is RateWaitingState) {
          return CommonLoading(message: "Ma'lumot yuklanmoqda...");
        } else if (state is RateErrorState) {
          return Container(
            height: 400.h,
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Xatolik yuz berdi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      state.message ?? "Ma'lumot yuklanmadi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      RateController.getAll(context);
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Qayta urinish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
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
