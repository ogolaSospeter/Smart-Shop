//A modal page to display the products based on the category selected
import 'package:flutter/material.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/reusables/widgets.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, required this.category});

  final String category;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isFetching = false;
  final FirestoreDatabaseHelper dbHelper = FirestoreDatabaseHelper();
  Future<List<Product>> _getCategoryProducts(String category) async {
    setState(() {
      isFetching = true;
    });
    print('Fetching products for category: $category');
    final categoryProducts = dbHelper.getCategoryProducts(category);
    setState(() {
      isFetching = false;
    });
    return categoryProducts;
  }

  @override
  Widget build(BuildContext context) {
    if (isFetching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Fetching products...'),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category.toUpperCase(),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                //Display the products in the categoryData
                //Use the ProductCard widget to display the products
                Wrap(children: [
                  FutureBuilder<List<Product>>(
                    future: _getCategoryProducts(widget.category),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!
                              .map((product) => ProductCards(
                                    product: product,
                                  ))
                              .toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Fetching products...'),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('No products found in this category'),
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text('Fetching products...'),
                          ],
                        ),
                      );
                    },
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    }
  }
}
