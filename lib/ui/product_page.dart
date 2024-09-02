import 'package:flutter/material.dart';
import 'package:smartshop/ui/home.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];
  final List<String> sizes = ["US 7", "US 8", "US 9", "US 10", "US 11"];
  // Variable to keep track of the selected color
  Color? selectedColor;
  Color selectedContainerColor = Colors.white;
  String selectedSize = "";
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Home();
                },
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Image.asset(
                widget.image,
                height: 160,
                width: 160,
                filterQuality: FilterQuality.high,
                color: selectedColor,
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
                              child: Image.asset(
                                widget.image,
                                height: 50,
                                width: 50,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),
              //add a row with the image title in uppercase and then some container to the end right having the price and the rating stars
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13.0,
                  vertical: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          widget.title.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      width: 90,
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
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "\$ 200",
                                    style: TextStyle(
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
                                  //add 5 golden stars iteratively
                                  for (int i = 0; i < 5; i++)
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13,
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
                  children: sizes.map((productSize) {
                    bool isSelected = selectedSize == productSize;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize =
                                productSize; // Update the selected size
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.deepPurple : Colors.white,
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
                                color: isSelected
                                    ? Colors.white
                                    : Colors.deepPurple,
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
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: color,
                        child: selectedColor == color
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
              const Text(
                "These versatile shoes feature a sleek silhouette, premium materials, and advanced cushioning technology, ensuring a perfect fit for any occasion. With a variety of colors and patterns available, these sneakers seamlessly blend fashion with functionality, making them an essential addition to your wardrobe. Whether for casual outings or athletic pursuits, experience unparalleled support and durability with every step.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      //add a floating action button with the cart icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}
