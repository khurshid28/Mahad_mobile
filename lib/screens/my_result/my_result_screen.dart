import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/section/section_screen.dart';
import 'package:test_app/widgets/my_result_card.dart';

class MyResultScreen extends StatefulWidget {
  
  @override
  _MyResultScreenState createState() => _MyResultScreenState();
}

class _MyResultScreenState extends State<MyResultScreen> {
  List<Section> sections = [
    Section(name: "Angliya XII asr", solved: 24, count: 40),
    Section(name: "Angliya XIV asr", solved: 17, count: 25),
    Section(name: "Angliya XIV asr", solved: 3, count: 25),
    Section(name: "Angliya XIV asr", solved: 5, count: 25),
    Section(name: "Angliya XIV asr", solved: 3, count: 25),
  ];

   List<Result> results = [
      Result(date: DateTime.now(), solved: 24,finished: false),
    Result(date: DateTime.now(), solved: 24),
    Result(date: DateTime(2025, 2, 24), solved: 17),
    Result(date: DateTime(2025, 1, 10), solved: 3),
     Result(date: DateTime(2025, 1, 10), solved: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: "Mening natijalarim", isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: 
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            sections.length,
            (index) => MyResultCard(section: sections[index],result: results[index], onTap: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionScreen(section: sections[index],),
                          ),
                        );
            }),
          ),
        ),
      ),
    );
  }
}
