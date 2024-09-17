import 'dart:ui';
import 'package:smartshop/models/category.dart';
import 'package:smartshop/models/database_products.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Set the path to the database.
    String path = join(await getDatabasesPath(), 'smart_shop.db');

    // Open the database.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create UserData table.
    await db.execute('''
      CREATE TABLE UserData(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        image TEXT,
        isLogged INTEGER NOT NULL,
        isAdmin INTEGER NOT NULL,
        UNIQUE(email)
      )
    ''');

    // Create Products table.
    await db.execute('''
      CREATE TABLE Products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        image TEXT NOT NULL,
        price REAL NOT NULL,
        discount REAL,
        sizes TEXT, 
        colors TEXT, 
        description TEXT,
        rating REAL NOT NULL,
        isLiked INTEGER NOT NULL,
        isSelected INTEGER NOT NULL,
        isCart INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        stocklevel INTEGER
        
      )
    ''');

    // Create Categories table.
    await db.execute('''
      CREATE TABLE Categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        isSelected INTEGER NOT NULL
      )
    ''');

    //Create the Orders table
    await db.execute('''
      CREATE TABLE Orders(
        id INTEGER PRIMARY KEY,
        orderDate TEXT NOT NULL,
        orderStatus TEXT NOT NULL,
        orderTotal REAL NOT NULL,
        itemId INTEGER NOT NULL,
        custId TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    //insert products to the database from the database_products list
    for (var product in database_products) {
      try {
        await db.insert('Products', {
          'name': product.name,
          'category': product.category,
          'image': product.image,
          'price': product.price,
          'discount': product.discount,
          'sizes': product.sizes.join(','),
          'colors': product.colors
              .map((color) => color.value.toRadixString(16))
              .join(','),
          'description': product.description,
          'rating': product.rating,
          'isLiked': product.isLiked ? 1 : 0,
          'isSelected': product.isSelected ? 1 : 0,
          'isCart': product.isCart ? 1 : 0,
          'quantity': product.quantity,
          //if the stock level is not provided, set it to the quantity
          'stocklevel': product.stocklevel,
        });
      } catch (e) {
        print('Error inserting product of name: ${product.name} due to $e');
      }
    }
  }

  // CRUD operations for UserData
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('UserData', {
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'image': user.image,
      'isLogged': user.isLogged ? 1 : 0,
      'isAdmin': user.isAdmin ? 1 : 0,
    });
  }

  //function to check if the username exists
  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final maps = await db.query(
      'UserData',
      where: 'username = ?',
      whereArgs: [username],
    );

    return maps.isNotEmpty;
  }

  Future<User?> getUserByUserName(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'UserData',
      where: 'username = ?',
      whereArgs: [username],
    );
    final map = maps[0];
    // Check for null id and handle accordingly
    if (map['id'] == null) {
      return null; // or handle it differently
    }

    return User(
      id: map['id'] as int, // Ensure this is not null
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      image: map['image'] as String,
      isLogged: (map['isLogged'] as int) == 1,
      isAdmin: (map['isAdmin'] as int) == 1,
    );
  }

  // Fetch the user data of the logged-in user.
  Future<User?> getLoggedInUser() async {
    final db = await database;
    final maps = await db.query(
      'UserData',
      where: 'isLogged = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      final map = maps[0];
      return User(
        id: map['id'] as int,
        username: map['username'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        image: map['image'] as String,
        isLogged: map['isLogged'] == 1, // Convert INTEGER to bool
        isAdmin: map['isAdmin'] == 1, // Convert INTEGER to bool
      );
    }
    return null;
  }

//Login a user
  Future<void> loginUser(String username) async {
    final db = await database;
    await db.update(
      'UserData',
      {'isLogged': 1},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  //Logout a user
  Future<void> logoutUser(String username) async {
    final db = await database;
    await db.update(
      'UserData',
      {'isLogged': 0},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  //Fetch all the users
  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('UserData');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'] as int,
        username: maps[i]['username'] as String,
        email: maps[i]['email'] as String,
        password: maps[i]['password'] as String,
        image: maps[i]['image'] as String,
        isLogged: maps[i]['isLogged'] == 1,
        isAdmin: maps[i]['isAdmin'] == 1,
      );
    });
  }

  // CRUD operations for Products
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('Products', {
      'name': product.name,
      'category': product.category,
      'image': product.image,
      'price': product.price,
      'discount': product.discount,
      'sizes': product.sizes.join(','), // Join sizes list into a string
      'colors': product.colors
          .map((color) => color.value.toRadixString(16))
          .join(','), // Convert colors to hex
      'description': product.description,
      'rating': product.rating,
      'isLiked': product.isLiked ? 1 : 0,
      'isSelected': product.isSelected ? 1 : 0,
      'isCart': product.isCart ? 1 : 0,
      'quantity': product.quantity,
      'stocklevel': product.stocklevel,
    });
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Products');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'] as String,
        category: maps[i]['category'] as String,
        image: maps[i]['image'] as String,
        price: maps[i]['price'] as double,
        discount: maps[i]['discount'] as double,
        sizes: (maps[i]['sizes'] as String)
            .split(','), // Split the string into a list
        colors: (maps[i]['colors'] as String)
            .split(',')
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(), // Convert hex back to Color
        description: maps[i]['description'] as String,
        rating: maps[i]['rating'] as double,
        isLiked: maps[i]['isLiked'] == 1,
        isSelected: maps[i]['isSelected'] == 1,
        isCart: maps[i]['isCart'] == 1,
        quantity: maps[i]['quantity'] as int,
        stocklevel: maps[i]['stocklevel'] as int,
      );
    });
  }

  //Get the product by id
  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps[0];
      return Product(
        id: map['id'],
        name: map['name'] as String,
        category: map['category'] as String,
        image: map['image'] as String,
        price: map['price'] as double,
        discount: map['discount'] as double,
        sizes: (map['sizes'] as String).split(','),
        colors: (map['colors'] as String)
            .split(',')
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: map['description'] as String,
        rating: map['rating'] as double,
        isLiked: map['isLiked'] == 1,
        isSelected: map['isSelected'] == 1,
        isCart: map['isCart'] == 1,
        quantity: map['quantity'] as int,
        stocklevel: map['stocklevel'] as int,
      );
    }
    return null;
  }

  // CRUD operations for Categories
  Future<int> insertCategory(Categories category) async {
    final db = await database;
    return await db.insert('Categories', {
      'name': category.name,
      'image': category.image,
      'isSelected': category.isSelected ? 1 : 0,
    });
  }

  Future<List<Categories>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categories');

    return List.generate(maps.length, (i) {
      return Categories(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        value: maps[i]['value'] as String,
        image: maps[i]['image'] as String,
        isSelected: maps[i]['isSelected'] == 1,
      );
    });
  }

  //Shopping cart items fetch for all the products with isSelected = 1
  Future<List<Product>> getShoppingCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      where: 'isCart = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'] as String,
        category: maps[i]['category'] as String,
        image: maps[i]['image'] as String,
        price: maps[i]['price'] as double,
        discount: maps[i]['discount'] as double,
        sizes: (maps[i]['sizes'] as String).split(','),
        colors: (maps[i]['colors'] as String)
            .split(',')
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: maps[i]['description'] as String,
        rating: maps[i]['rating'] as double,
        isLiked: maps[i]['isLiked'] == 1,
        isSelected: maps[i]['isSelected'] == 1,
        isCart: maps[i]['isCart'] == 1,
        quantity: maps[i]['quantity'] as int,
        stocklevel: maps[i]['stocklevel'] as int,
      );
    });
  }

  //Check if the product is already in the shopping cart
  Future<bool> isProductInCart(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      where: 'id = ? AND isCart = ?',
      whereArgs: [id, 1],
    );

    return maps.isNotEmpty;
  }

  //The 4 products with the highest discount
  Future<List<Product>> getTopDiscountedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      orderBy: 'discount DESC',
      limit: 4,
    );

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'] as String,
        category: maps[i]['category'] as String,
        image: maps[i]['image'] as String,
        price: maps[i]['price'] as double,
        discount: maps[i]['discount'] as double,
        sizes: (maps[i]['sizes'] as String).split(','),
        colors: (maps[i]['colors'] as String)
            .split(',')
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(),
        description: maps[i]['description'] as String,
        rating: maps[i]['rating'] as double,
        isLiked: maps[i]['isLiked'] == 1,
        isSelected: maps[i]['isSelected'] == 1,
        isCart: maps[i]['isCart'] == 1,
        quantity: maps[i]['quantity'] as int,
        stocklevel: maps[i]['stocklevel'] as int,
      );
    });
  }

  //Update the isSelected field of the product
  Future<void> updateCartProduct(int id, bool isCart) async {
    final db = await database;
    await db.update(
      'Products',
      {'isCart': isCart ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Update the isLiked field of the product
  Future<void> updateProductLike(int id, bool isLiked) async {
    final db = await database;
    await db.update(
      'Products',
      {'isLiked': isLiked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Delete the product from the shopping cart by setting isSelected = 0
  Future<void> deleteProductFromCart(int id) async {
    await updateCartProduct(id, false);
  }

/////////////////////////////////////////////
//Adding an order to the database
  Future<int> insertOrder(Orders order) async {
    final db = await database;

    return await db.insert('Orders', {
      'id': order.orderId,
      'orderDate': order.orderDate,
      'orderStatus': order.orderStatus,
      'orderTotal': order.orderTotal,
      'itemId': order.itemId,
      'custId': order.custId,
      'quantity': order.quantity,
    });
  }

  //Fetch the orders of a particular user
  Future<List<Orders>> getOrdersByUser(String custId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Orders',
      where: 'custId = ?',
      whereArgs: [custId],
    );

    return List.generate(maps.length, (i) {
      return Orders(
        orderId: maps[i]['id'] as int,
        orderDate: maps[i]['orderDate'] as String,
        orderPhone: maps[i]['orderPhone'] as String,
        orderStatus: maps[i]['orderStatus'] as String,
        orderTotal: maps[i]['orderTotal'] as double,
        itemId: maps[i]['itemId'],
        custId: maps[i]['custId'] as String,
        quantity: maps[i]['quantity'] as int,
      );
    });
  }

  //Fetch the orders of a particular user
  Future<List<Orders>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Orders',
    );

    return List.generate(maps.length, (i) {
      return Orders(
        orderId: maps[i]['id'] as int,
        orderDate: maps[i]['orderDate'] as String,
        orderPhone: maps[i]['orderPhone'] as String,
        orderStatus: maps[i]['orderStatus'] as String,
        orderTotal: maps[i]['orderTotal'] as double,
        itemId: maps[i]['itemId'],
        custId: maps[i]['custId'] as String,
        quantity: maps[i]['quantity'] as int,
      );
    });
  }

//Check if the order already exists for the same user and on the same date. The date is in currentDate.millisecondsSinceEpoch,. Only compare the date part of the orderDate
  Future<bool> isOrderExists(
      String custId, int itemId, String orderDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Orders',
      where: 'custId = ? AND itemId = ? AND orderDate = ?',
      whereArgs: [custId, itemId, orderDate],
    );
    return maps.isNotEmpty;
  }

  //Update the order status
  Future<void> updateOrderStatus(int orderId, String orderStatus) async {
    final db = await database;
    await db.update(
      'Orders',
      {'orderStatus': orderStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  //get Product quantity
  Future<int> getProductQuantity(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps[0]['quantity'] as int;
    }
    return 0;
  }

  //Get the stock level of the product
  Future<int> getProductStockLevel(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps[0]['stocklevel'] as int;
    }
    return 0;
  }

  //Update the Product quantity
  Future<void> updateProductStockLevel(int id, int quantity) async {
    final db = await database;
    await db.update(
      'Products',
      {'stocklevel': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> cancelOrder(int orderId) async {
    final db = await database;
    const String cancel = 'Cancelled';
    await db.update(
      'Orders',
      {'orderStatus': cancel},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
