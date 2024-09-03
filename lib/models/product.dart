//Modelling the product data
import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  String category;
  String image;
  double price;
  List<String> sizes;
  List<Color> colors;
  double rating;
  bool isLiked;
  bool isSelected;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.image,
      required this.price,
      required this.sizes,
      required this.colors,
      required this.rating,
      required this.isLiked,
      required this.isSelected});
}
