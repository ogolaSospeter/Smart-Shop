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
  final FirestoreDatabaseHelper dbHelper = FirestoreDatabaseHelper();

  Future<List<Product>> _getCategoryProducts(String category) async {
    return dbHelper.getCategoryProducts(category);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Product>>(
          future: _getCategoryProducts(widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_outlined,
                      size: 50,
                    ),
                    Text('No products found in this category'),
                  ],
                ),
              );
            } else {
              // If data is fetched successfully, display the products
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: snapshot.data!
                      .map((product) => ProductCards(product: product))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
