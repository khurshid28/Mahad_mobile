// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:test_app/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Color backgroundColor;
  final Color borderColor; // Har bir subject uchun alohida border rangi
 final VoidCallback onTap;
  BookCard({
    required this.book,
    required this.backgroundColor,
    required this.borderColor, required   this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.5), // Fanning o‘ziga mos rang
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              book.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
