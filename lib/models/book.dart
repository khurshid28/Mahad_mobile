import 'package:flutter/material.dart';

class Book {
  final String name;
  final String imagePath;
  final Color? color;
  final Color? borderColor;
  final int id;
  final int passingPercentage;
  final bool fullBlock;
  final bool stepBlock;

  

  Book({
    required this.name, 
    required this.imagePath,  
    this.color,  
    this.borderColor,
    required this.id,
    this.passingPercentage = 60,
    this.fullBlock = false,
    this.stepBlock = false,
  });
}
