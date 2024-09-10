import 'package:flutter/material.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/category.dart';
import 'package:smartshop/models/database_products.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/reusables/widgets.dart';
import 'package:smartshop/ui/signIn.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final DatabaseHelper dbHelper = DatabaseHelper();

// All products from the database
  Future<List<Product>> _getProducts() async {
    final products = dbHelper.getProducts();
    return products;
  }

  Future<List<Product>> _getHotDeals() async {
    final hotDeals = dbHelper.getTopDiscountedProducts();
    return hotDeals;
  }

  Future<Future<List<Categories>>> _getCategories() async {
    final categories = dbHelper.getCategories();
    return categories;
  }

  Future<List<Product>> _getDeals() async {
    final deals = dbHelper.getTopDiscountedProducts();
    return deals;
  }

  final List<Product> deals = [];

  @override
  void initState() {
    super.initState();
    _getDeals().then((value) {
      setState(() {
        deals.addAll(value);
      });
    });
  }

  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Our",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Products",
              style: TextStyle(
                fontSize: 43,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for products",
                        border: InputBorder.none,
                        icon: IconButton(
                          onPressed: () {
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                ),
                              },
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Daily Deals",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DailyDeals(deals: deals),
            const Text(
              "Categories",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            //the categories include Shirts, Trousers, Shoes, Hats, Sneakers, Suits, Dresses, Skirts, and Accessories
            //use a scrollable row to display the categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories.map(
                  (category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CategoryWidget(category: category),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Hot Deals🔥",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                FutureBuilder<List<Product>>(
                  future: _getHotDeals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loading indicator while fetching data
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle any errors
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // If data is fetched successfully
                      var products = snapshot.data!.take(6);
                      return Wrap(
                        children: products.map((product) {
                          return HotDealsCards(product: product);
                        }).toList(),
                      );
                    } else {
                      // Handle the case when there's no data
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Featured ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                FutureBuilder<List<Product>>(
                  future: _getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loading indicator while fetching data
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle any errors
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // If data is fetched successfully
                      var products = snapshot.data!.take(6);
                      return Wrap(
                        children: products.map((product) {
                          return ProductCards(product: product);
                        }).toList(),
                      );
                    } else {
                      // Handle the case when there's no data
                      return const Text('No products found.');
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
