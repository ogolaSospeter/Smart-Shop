//Modelling the product data
class Product {
  int id;
  String name;
  String category;
  String image;
  double price;
  List<String> sizes;
  List<String> colors;
  double rating;
  bool isliked;
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
      required this.isliked,
      required this.isSelected});
}
