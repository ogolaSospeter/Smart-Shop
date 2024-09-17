// ignore_for_file: control_flow_in_finally

import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/product.dart';

Future<int> initializeDatabase(List<Product> productsList) async {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  var results = 0;
  try {
    for (var product in productsList) {
      await databaseHelper.insertProduct(product);
    }
    results = 1;
  } catch (e) {
    results = 0;
  } finally {
    return results;
  }
}
