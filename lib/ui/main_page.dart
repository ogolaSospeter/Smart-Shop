import 'package:flutter/material.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/database_products.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/reusables/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final FirestoreDatabaseHelper dbHelper = FirestoreDatabaseHelper();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  var isFetching = false;

// All products from the database
  Future<List<Product>> _getProducts() async {
    isFetching = true;
    final products = dbHelper.getProducts();
    isFetching = false;
    return products;
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isFetching = true;
    });
    final products = await dbHelper.getProducts();
    setState(() {
      allProducts = products;
      filteredProducts =
          products; // Initialize filteredProducts with all products
      isFetching = false;
    });
  }

  Future<List<Product>> _getHotDeals() async {
    setState(() {
      isFetching = true;
    });
    final hotDeals = dbHelper.getTopDiscountedProducts();
    setState(() {
      isFetching = false;
    });
    return hotDeals;
  }

  final List<Product> deals = [];

  @override
  void initState() {
    super.initState();
    _getHotDeals().then((value) {
      setState(() {
        deals.addAll(value);
      });
    });
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  //filter products by category

  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    isFetching = false;
    if (isFetching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                      onChanged: (value) => _filterProducts(),
                      decoration: InputDecoration(
                        hintText: "Search for products",
                        border: InputBorder.none,
                        icon: IconButton(
                          onPressed: () {
                            GestureDetector(
                              onTap: () => {
                                //Search for product
                                _filterProducts(),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
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
            ),
            const SizedBox(height: 30),
            const Text(
              "Recommended for you",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            StaggeredGrid.count(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 10,
              children: filteredProducts.map((product) {
                return ProductCards(product: product);
              }).toList(),
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.vertical,
            //   child: Wrap(
            //     alignment: WrapAlignment.start,
            //     children: [
            //       Wrap(
            //         children: filteredProducts.map((product) {
            //           return ProductCards(product: product);
            //         }).toList(),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
