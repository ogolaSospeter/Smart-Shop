import 'package:flutter/material.dart';

class Categories {
  int id;
  String name;
  String value;
  Icon image;
  bool isSelected;

  Categories(
      {required this.id,
      required this.name,
      required this.value,
      required this.image,
      required this.isSelected});
}
