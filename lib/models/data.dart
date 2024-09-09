import 'package:flutter/material.dart';
import 'package:smartshop/models/product.dart';

class AppData {
  static List<Product> productList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        discount: 15.3,
        isSelected: true,
        isLiked: false,
        image: 'assets/shooe_tilt_1.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'Nike Air Max 200 is the latest model of the Air Max series. It is a versatile and timeless shoe that is perfect for any occasion. The shoe features the iconic Waffle sole, stitched overlays, and classic TPU accents that you have come to love. The shoe is available in a variety of colors and sizes, so you can find the perfect fit for you. The Nike Air Max 200 is a classic shoe that will never go out of style. It is the perfect shoe for any occasion, whether you are going for a run or just hanging out with friends. The shoe is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead. The Nike Air Max 200 is the perfect shoe for any occasion. It is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead. The shoe is available in a variety of colors and sizes, so you can find the perfect fit for you. The Nike Air Max 200 is the perfect shoe for any occasion. It is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead.',
        rating: 4.8),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 220.00,
        discount: 10.2,
        isLiked: false,
        isSelected: false,
        image: 'assets/shoe_tilt_2.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'This Nike Air Max 97 is a classic shoe that will never go out of style. It is the perfect shoe for any occasion, whether you are going for a run or just hanging out with friends. The shoe is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead. The Nike Air Max 97 is the perfect shoe for any occasion. It is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead. The shoe is available in a variety of colors and sizes, so you can find the perfect fit for you. The Nike Air Max 97 is the perfect shoe for any occasion. It is comfortable, stylish, and durable, making it the perfect choice for any sneakerhead.',
        rating: 4.8),
  ];
  static List<Product> cartList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        discount: 13.8,
        isSelected: true,
        isLiked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.',
        rating: 4.8),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 190.00,
        discount: 7.8,
        isLiked: false,
        isSelected: true,
        image: 'assets/small_tilt_shoe_2.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.',
        rating: 4.8),
    Product(
        id: 1,
        name: 'Nike Air Max 92607',
        price: 220.00,
        discount: 10.2,
        isLiked: false,
        isSelected: true,
        image: 'assets/small_tilt_shoe_3.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.',
        rating: 4.8),
    Product(
        id: 2,
        name: 'Nike Air Max 200',
        price: 240.00,
        discount: 1,
        isSelected: true,
        isLiked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now",
        sizes: ["US 7", "US 8", "US 9", "US 10", "US 11"],
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],
        description:
            'The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.',
        rating: 4.8),
  ];

  static List<String> showThumbnailList = [
    "assets/shoe_thumb_5.png",
    "assets/shoe_thumb_1.png",
    "assets/shoe_thumb_4.png",
    "assets/shoe_thumb_3.png",
  ];
  static String description =
      "Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.";
}
