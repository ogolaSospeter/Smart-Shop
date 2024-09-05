import 'package:flutter/material.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/ui/home.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isFavorite = false;
  final DatabaseHelper dbHelper = DatabaseHelper();

  //Get the product data from the database
  Future<Product?> _getProductData() async {
    return await dbHelper.getProductById(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Transition back to the home page with a scale-out effect
            Navigator.of(context).pop(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const Home();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  );
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 0.0)
                        .animate(curvedAnimation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(seconds: 3),
              ),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          //add the favorite icon
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: isFavorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
          ),
        ],
        scrolledUnderElevation: 1.2,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Center(
            child: FutureBuilder(
              future: _getProductData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  final product = snapshot.data as Product;
                  return ProductDetails(product: product);
                }
              },
            ),
          ),
        ),
      ),
      //add a floating action button with the cart icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //add the product to the cart
          dbHelper.updateProductSelection(widget.product.id, true);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}

//create the ProductDetails widget
// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  ProductDetails({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var selectedColor = Colors.transparent;

  var selectedSize = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
          height: 170,
          width: 170,
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedColor == Colors.transparent
                  ? selectedColor
                  : Colors.deepPurple,
              width: 2,
            ),
            backgroundBlendMode: BlendMode.modulate,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.network(
            widget.product.image,
            height: 160,
            width: 160,
            scale: 1.0,
            filterQuality: FilterQuality.high,
            color: selectedColor == Colors.transparent ? null : selectedColor,
            colorBlendMode: BlendMode.modulate,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const CircularProgressIndicator(),
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              } else {
                return AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //add a row with other images of the product in outlined containers which are clickable
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //add 3 images iteratively
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 65,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.network(
                          widget.product.image,
                          height: 50,
                          width: 50,
                          filterQuality: FilterQuality.high,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : const CircularProgressIndicator(
                                      color: Colors.deepPurple,
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // 0716799836
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.product.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  textWidthBasis: TextWidthBasis.parent,
                ),
              ),
              Container(
                height: 60,
                width: 120,
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "\$ ${widget.product.price}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        //Add a row with the rating stars
                        Row(
                          children: [
                            // Full stars for the integer part of the rating
                            for (int i = 0;
                                i < widget.product.rating.floor();
                                i++)
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 20,
                              ),

                            // Half star if the rating has a decimal part
                            if (widget.product.rating -
                                    widget.product.rating.floor() >=
                                0.5)
                              const Icon(
                                Icons.star_half,
                                color: Colors.yellow,
                                size: 20,
                              ),

                            // Empty stars for the remaining part to make 5 stars
                            for (int i = widget.product.rating.ceil();
                                i < 5;
                                i++)
                              const Icon(
                                Icons.star_border,
                                color: Colors.yellow,
                                size: 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        //The available sizes
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                "Available Sizes",
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //add a row with the sizes in outlined containers
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.sizes.map((productSize) {
              bool isSelected = selectedSize == productSize;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = productSize;
                    });
                  },
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.white,
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "US $productSize",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.deepPurple,
                          fontSize: 12,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //add a row with the color options that when clicked changes the color of the product image
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                "Available Colors",
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //add a row with different colors in outlined circular containers that when clicked changes the color of the product image and shows a check icon within the container
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.product.colors.map((prodcolor) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  //if the color is transparent, set the selected color to null
                  selectedColor =
                      (prodcolor == Colors.transparent ? null : prodcolor)!;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColor == prodcolor
                        ? Colors.deepPurple
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: prodcolor,
                  child: selectedColor == prodcolor
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Product description
        Text(
          widget.product.description,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
