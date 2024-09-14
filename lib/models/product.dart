//Modelling the product data
import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  String category;
  String image;
  double price;
  double discount;
  List<String> sizes;
  List<Color> colors;
  String description;
  double rating;
  bool isLiked;
  bool isSelected;
  bool isCart;
  int quantity;
  int stocklevel;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.discount,
    required this.sizes,
    required this.colors,
    required this.description,
    required this.rating,
    required this.isLiked,
    required this.isSelected,
    required this.isCart,
    required this.quantity,
    required this.stocklevel,
  });
}
