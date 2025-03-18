import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:test_app/widgets/custom_text_field.dart';
import 'package:test_app/widgets/saved_card.dart';
import 'package:test_app/widgets/subject_card.dart';

import '../section/section_screen.dart';

class SavedBody extends StatefulWidget {
  @override
  _SavedBodyState createState() => _SavedBodyState();
}

class _SavedBodyState extends State<SavedBody> {
  final List<Book> books = [
    Book(name: "Germaniya tarixi", imagePath: "assets/images/history.png"),
    Book(name: "Angliya tarixi", imagePath: "assets/images/adabiyot.png"),
    Book(name: "O'rta Osiyo tarixi", imagePath: "assets/images/matematika.png"),
    Book(name: "Fransiya tarixi", imagePath: "assets/images/matematika.png"),
  ];


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
      backgroundColor: AppConstant.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:   Column(
                children: List.generate(
                  books.length,
                  (index) => SavedCard(
                    book: books[index],
                    subject: Subject(
                      name: "Tarix",
                      imagePath: books[index].imagePath,
                    ),
                    onTap: () {
                       Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SectionScreen(section: sections[index],),
                                ),
                              );
                    },
                  ),
                ),
              ),
         
      ),
    );
  }
}
