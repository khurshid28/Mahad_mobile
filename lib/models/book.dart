import 'package:flutter/material.dart';

class Book {
  final String name;
  final String imagePath;
  final Color? color;
  final Color? borderColor;
  final int id;

  

  Book({required this.name, required this.imagePath,  this.color,  this.borderColor,required this.id});
}
