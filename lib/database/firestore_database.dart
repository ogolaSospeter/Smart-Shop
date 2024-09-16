import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/models/category.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/models/user.dart';

class FirestoreDatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD operations for UserData
  Future<void> insertUser(User user) async {
    await _firestore.collection('users').doc(user.email).set({
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'image': user.image,
      'isLogged': user.isLogged,
      'isAdmin': user.isAdmin,
    });
  }

  Future<bool> isUsernameExists(String username) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<User?> getUserByUserName(String username) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      return User(
        id: 0,
        username: data['username'],
        email: data['email'],
        password: data['password'],
        image: data['image'],
        isLogged: data['isLogged'],
        isAdmin: data['isAdmin'],
      );
    }
    return null;
  }

  Future<User?> getLoggedInUser() async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('isLogged', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      return User(
        id: data['id'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        image: data['image'],
        isLogged: data['isLogged'],
        isAdmin: data['isAdmin'],
      );
    }
    return null;
  }

  Future<void> loginUser(String username) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('users')
          .doc(docId)
          .update({'isLogged': true});
    }
  }

  Future<void> logoutUser(String username) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('users')
          .doc(docId)
          .update({'isLogged': false});
    }
  }

  Future<List<User>> getUsers() async {
    var querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return User(
        id: data['id'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        image: data['image'],
        isLogged: data['isLogged'],
        isAdmin: data['isAdmin'],
      );
    }).toList();
  }

  // CRUD operations for Products
  Future<void> insertProduct(Product product) async {
    await _firestore.collection('products').add({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'name': product.name,
      'category': product.category,
      'image': product.image,
      'price': product.price,
      'discount': product.discount,
      'sizes': product.sizes, // This will store as an array
      'colors': product.colors
          .map((color) => color.value.toRadixString(16))
          .toList(), // Convert colors to hex and store as array
      'description': product.description,
      'rating': product.rating,
      'isLiked': product.isLiked,
      'isSelected': product.isSelected,
      'isCart': product.isCart,
      'quantity': product.quantity,
      'stocklevel': product.stocklevel,
    });
  }

  Future<List<Product>> getProducts() async {
    var querySnapshot = await _firestore.collection('products').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Product(
        //return the document id as the product id
        id: data['id'],
        name: data['name'],
        category: data['category'],
        image: data['image'],
        price: data['price'],
        discount: data['discount'],
        sizes: List<String>.from(data['sizes']),
        colors: List<String>.from(data['colors'])
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: data['description'],
        rating: data['rating'],
        isLiked: data['isLiked'],
        isSelected: data['isSelected'],
        isCart: data['isCart'],
        quantity: data['quantity'],
        stocklevel: data['stocklevel'],
      );
    }).toList();
  }

  // CRUD operations for Categories
  Future<void> insertCategory(Categories category) async {
    await _firestore.collection('categories').add({
      'name': category.name,
      'image': category.image,
      'isSelected': category.isSelected,
    });
  }

  Future<List<Categories>> getCategories() async {
    var querySnapshot = await _firestore.collection('categories').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Categories(
        id: 0,
        name: data['name'],
        image: data['image'],
        isSelected: data['isSelected'],
      );
    }).toList();
  }

  // Shopping cart items fetch
  Future<List<Product>> getShoppingCartItems() async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('isCart', isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Product(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        image: data['image'],
        price: data['price'],
        discount: data['discount'],
        sizes: List<String>.from(data['sizes']),
        colors: List<String>.from(data['colors'])
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: data['description'],
        rating: data['rating'],
        isLiked: data['isLiked'],
        isSelected: data['isSelected'],
        isCart: data['isCart'],
        quantity: data['quantity'],
        stocklevel: data['stocklevel'],
      );
    }).toList();
  }

  // The 4 products with the highest discount
  Future<List<Product>> getTopDiscountedProducts() async {
    var querySnapshot = await _firestore
        .collection('products')
        .orderBy('discount', descending: true)
        .limit(5)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Product(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        image: data['image'],
        price: data['price'],
        discount: data['discount'],
        sizes: List<String>.from(data['sizes']),
        colors: List<String>.from(data['colors'])
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: data['description'],
        rating: data['rating'],
        isLiked: data['isLiked'],
        isSelected: data['isSelected'],
        isCart: data['isCart'],
        quantity: data['quantity'],
        stocklevel: data['stocklevel'],
      );
    }).toList();
  }

  // Update the isSelected field of the product
  Future<void> updateProductSelection(String id, bool isCart) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('products')
          .doc(docId)
          .update({'isCart': isCart});
    }
  }

  // Update the isLiked field of the product
  Future<void> updateProductLike(String id, bool isLiked) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('products')
          .doc(docId)
          .update({'isLiked': isLiked});
    }
  }

  // Delete the product from the shopping cart by setting isSelected = 0
  Future<void> deleteProductFromCart(String id) async {
    await updateProductSelection(id, false);
  }

  // Adding an order to the database
  Future<void> insertOrder(Orders order) async {
    await _firestore.collection('orders').add({
      'orderId': DateTime.now().microsecondsSinceEpoch,
      'orderDate': order.orderDate,
      'orderPhone': order.orderPhone,
      'orderStatus': order.orderStatus,
      'orderTotal': order.orderTotal,
      'itemId': order.itemId,
      'custId': order.custId,
      'quantity': order.quantity,
    });
  }

  // Fetch the orders of a particular user
  Future<List<Orders>> getOrdersByUser(String custId) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('custId', isEqualTo: custId)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Orders(
        orderId: data['orderId'],
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  // Check if the order already exists for the same user and on the same date
  Future<bool> isOrderExists(
      String custId, int itemId, String orderDate) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('custId', isEqualTo: custId)
        .where('itemId', isEqualTo: itemId)
        .where('orderDate', isEqualTo: orderDate)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Update the order status

  Future<void> updateOrderStatus(int orderId, String orderStatus) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('orders')
          .doc(docId)
          .update({'orderStatus': orderStatus});
    }
  }

//get Product Stock Level
  Future<int> getProductStockLevel(String id) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      return data['stocklevel'];
    }
    return 0;
  }

  // Update the stock level of the product
  Future<void> updateProductStockLevel(String id, int stocklevel) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('products')
          .doc(docId)
          .update({'stocklevel': stocklevel});
    }
  }

  // Get the product by id
  Future<Product?> getProductById(String id) async {
    var docSnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (docSnapshot.docs.isNotEmpty) {
      var data = docSnapshot.docs.first.data();
      return Product(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        image: data['image'],
        price: data['price'],
        discount: data['discount'],
        sizes: List<String>.from(data['sizes']),
        colors: List<String>.from(data['colors'])
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: data['description'],
        rating: data['rating'],
        isLiked: data['isLiked'],
        isSelected: data['isSelected'],
        isCart: data['isCart'],
        quantity: data['quantity'],
        stocklevel: data['stocklevel'],
      );
    }
    return null;
  }

  // Fetch the orders
  Future<List<Orders>> getOrders() async {
    var querySnapshot = await _firestore.collection('orders').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Orders(
        orderId: data['orderId'],
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  //isProductinCart
  Future<bool> isProductInCart(String id) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .where('isCart', isEqualTo: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  //updateCartProduct
  Future<void> updateCartProduct(String id, bool isCart) async {
    var querySnapshot = await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('products')
          .doc(docId)
          .update({'isCart': isCart});
    }
  }

  // Fetch the order details
  Future<Orders?> getOrderById(int orderId) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      return Orders(
        orderId: 0,
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }
    return null;
  }

  // Delete the order
  Future<void> deleteOrder(int orderId) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore.collection('orders').doc(docId).delete();
    }
  }

  // Fetch the orders by status
  Future<List<Orders>> getOrdersByStatus(String orderStatus) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderStatus', isEqualTo: orderStatus)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Orders(
        orderId: data['orderId'],
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  // Fetch the orders by date
  Future<List<Orders>> getOrdersByDate(String orderDate) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderDate', isEqualTo: orderDate)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Orders(
        orderId: data['orderId'],
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  // Fetch the orders by user and status
  Future<List<Orders>> getOrdersByUserAndStatus(
      String custId, String orderStatus) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('custId', isEqualTo: custId)
        .where('orderStatus', isEqualTo: orderStatus)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Orders(
        orderId: data['orderId'],
        orderDate: data['orderDate'],
        orderPhone: data['orderPhone'],
        orderStatus: data['orderStatus'],
        orderTotal: data['orderTotal'],
        itemId: data['itemId'],
        custId: data['custId'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  //cancelOrder
  Future<void> cancelOrder(int orderId) async {
    var querySnapshot = await _firestore
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('orders')
          .doc(docId)
          .update({'orderStatus': 'Cancelled'});
    }
  }
}
