// ignore_for_file: control_flow_in_finally

import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/database_products.dart';
import 'package:smartshop/models/product.dart';

Future<void> main() async {
  final result = await initializeDatabase(database_products);
  if (result == 1) {
    print('Database initialized successfully');
  } else {
    print('Database initialization failed');
  }
}

Future<int> initializeDatabase(List<Product> productsList) async {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  var results = 0;
  try {
    for (var product in productsList) {
      await databaseHelper.insertProduct(product);
      print('Product ${product.name} inserted');
    }
    results = 1;
  } catch (e) {
    results = 0;
  } finally {
    return results;
  }
}
