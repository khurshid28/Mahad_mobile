import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/rate.dart';
import 'package:test_app/widgets/rate_card.dart';

class RateScreen extends StatefulWidget {
  
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  List<Rate> rates = [
    Rate(name: "Ismoilov Xurshid", rate: 1,try_count: 4,avg: 81.7,imagePath:"assets/images/profile.jpg" ),
    Rate(name: "Davlatov MuhammadUmar", rate: 2,try_count: 2,avg: 68.4,imagePath:"assets/images/profile.jpg" ),
    Rate(name: "Bahodirov Alisher", rate: 3,try_count: 8,avg: 35,imagePath:"assets/images/profile.jpg" ),
    Rate(name: "Shermat Aliyev", rate: 4,try_count: 2,avg: 22.5,imagePath:"assets/images/profile.jpg" ),
    Rate(name: "Elbek Ergashov", rate: 5,try_count: 0,avg: 0,imagePath:"assets/images/profile.jpg" ),
    Rate(name: "Shaxriyor G'ulomov", rate: 6,try_count: 0,avg: 0,imagePath:"assets/images/profile.jpg" ),
   
  ];

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: "Liderlar", isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: 
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: List.generate(
            rates.length,
            (index) => RateCard(rate: rates[index], onTap: () {
               
            }),
          ),
        ),
      ),
    );
  }
}
