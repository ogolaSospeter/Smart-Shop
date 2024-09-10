import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartshop/models/category.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/ui/product_page.dart';

class CategoryWidget extends StatefulWidget {
  final Categories category;

  const CategoryWidget({super.key, required this.category});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[200]!,
                  width: 2,
                ),
                shape: BoxShape.rectangle,
              ),
              child: ListTile(
                leading: Image.network(
                  widget.category.image,
                  height: 25,
                  width: 25,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                    value: 10,
                  ),
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                              value: 10,
                            ),
                ),
                title: Text(widget.category.name),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class ProductCards extends StatelessWidget {
  const ProductCards({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProductPage(product: product);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const curve = Curves.easeIn;
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: curve);

              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              );
            },
            transitionDuration:
                const Duration(milliseconds: 600), // Slow down the animation
          ),
        );
      },
      child: SizedBox(
        height: 200,
        width: 160,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 75.0, top: 5.0),
                child: Icon(Icons.favorite_outline_outlined,
                    color: Colors.red, size: 30),
              ),
              const SizedBox(height: 5),
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.network(
                  product.image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const LinearProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class HotDealsCards extends StatelessWidget {
  const HotDealsCards({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProductPage(product: product);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const curve = Curves.easeIn;
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: curve);

              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              );
            },
            transitionDuration:
                const Duration(milliseconds: 600), // Slow down the animation
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.315,
        width: 190,
        child: Card(
          color: Colors.deepPurpleAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    '\t\t${product.discount} % OFF',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.network(
                  product.image,
                  height: 160,
                  width: 170,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const LinearProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '\$${(product.price - (product.price * product.discount / 100)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyDeals extends StatefulWidget {
  final List<Product> deals;

  const DailyDeals({super.key, required this.deals});

  @override
  _DailyDealsState createState() => _DailyDealsState();
}

class _DailyDealsState extends State<DailyDeals> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Set up a timer to automatically change the deal
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.deals.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity, // Take up the full width of the screen
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.deals.length,
        itemBuilder: (context, index) {
          final deal = widget.deals[index];
          return _buildDealCard(deal);
        },
      ),
    );
  }

  Widget _buildDealCard(Product deal) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deal.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      "${deal.description.substring(0, 100)} + .",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    //show the discount price in an elevated button
                    child: Text(
                      '${deal.discount} % OFF',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - (175),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: 5)
                    ],
                    image: DecorationImage(
                      image: NetworkImage(deal.image),
                      fit: BoxFit.cover,
                      invertColors: false,
                    ),
                  ),
                ),

                // Image.network(
                //   deal.image,
                //   height: 180,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.fill,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Deal {
  final String name;
  final String description;
  final String image;

  Deal({required this.name, required this.description, required this.image});
}
