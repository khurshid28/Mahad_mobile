import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/screens/section/section_screen.dart';
import 'package:test_app/widgets/section_card.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  BookScreen({required this.book});
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<Section> sections = [
    Section(name: "Angliya XII asr", solved: 24, count: 40),
    Section(name: "Angliya XIV asr", solved: 17, count: 25),
    Section(name: "Angliya XIV asr", solved: 3, count: 25),
    Section(name: "Angliya XIV asr", solved: 0, count: 25),
    Section(name: "Angliya XIV asr", solved: 0, count: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(titleText: widget.book.name, isLeading: true),
      ),
      backgroundColor: AppConstant.whiteColor,
      body: 
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            sections.length,
            (index) => SectionCard(section: sections[index], onTap: () {
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
