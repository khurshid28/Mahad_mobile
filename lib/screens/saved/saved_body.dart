import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/book.dart';
import 'package:test_app/models/section.dart';
import 'package:test_app/models/subject.dart';
import 'package:test_app/screens/book/book_screen.dart';
import 'package:test_app/service/storage_service.dart';
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
    // Book(name: "Germaniya tarixi", imagePath: "assets/images/history.png",id: 1),
    // Book(name: "Angliya tarixi", imagePath: "assets/images/adabiyot.png",id: 1),
    // Book(name: "O'rta Osiyo tarixi", imagePath: "assets/images/matematika.png",id :1),
    // Book(name: "Fransiya tarixi", imagePath: "assets/images/matematika.png",id:1),
  ];

  // List<Section> sections = [
  // Section(name: "Angliya XII asr",  count: 40),
  // Section(name: "Angliya XIV asr",  count: 25),
  // Section(name: "Angliya XIV asr", count: 25),
  // Section(name: "Angliya XIV asr", count: 25),
  // Section(name: "Angliya XIV asr", count: 25),
  // ];

  List getSections() {
    return ((StorageService().read("${StorageService.sections}") ?? {}) as Map)
        .entries
        .map((e) => e.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List sections = getSections();
    return Scaffold(
      backgroundColor: AppConstant.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            sections.length,
            (index) => SavedCard(
              book: Book(
                name: sections[index]?["book"]?["name"] ?? "",
                imagePath: sections[index]["book"]?["image"] ?? "",
                id: sections[index]["book"]?["id"] ?? 1,
              ),
              subject: Subject(
                name: sections[index]?["book"]?["subject"]?["name"] ?? "",
                imagePath: sections[index]?["book"]?["subject"]?["image"] ?? "",
                id: sections[index]["book"]?["subject"]?["id"] ?? 1,
              ),
              onTap: () async {
                Section section = Section(
                  name: sections[index]["name"],
                  id: sections[index]["id"],
                  count: sections[index]["test"]?["_count"]?["test_items"] ?? 1,
                  test_id: sections[index]["test"]?["id"],
                );
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectionScreen(section: section),
                  ),
                );
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
