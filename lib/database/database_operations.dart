import 'dart:ui';
import 'package:smartshop/models/category.dart';
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

  // static final DatabaseHelper _instance = DatabaseHelper._internal();
  // static Database? _database;

  // factory DatabaseHelper() {
  //   return _instance;
  // }

  // DatabaseHelper._internal();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;

  //   _database = await _initDatabase();
  //   return _database!;
  // }

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
        isLogged INTEGER NOT NULL
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
        sizes TEXT, -- Store as a comma-separated string
        colors TEXT, -- Store as a comma-separated string of hex colors
        rating REAL NOT NULL,
        isLiked INTEGER NOT NULL,
        isSelected INTEGER NOT NULL
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
    );
  }

  // Future<User?> getUserByUserName(String username) async {
  //   final db = await database;
  //   final maps = await db.query(
  //     'UserData',
  //     where: 'username = ?',
  //     whereArgs: [username],
  //   );

  //   if (maps.isNotEmpty) {
  //     final map = maps[0];
  //     return User(
  //       id: map['id'] as int,
  //       username: map['username'] as String,
  //       email: map['email'] as String,
  //       password: map['password'] as String,
  //       image: map['image'] as String,
  //       isLogged: (map['isLogged'] as int) == 1, // Convert INTEGER to bool
  //     );
  //   }
  //   return null;
  // }

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

  // CRUD operations for Products
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('Products', {
      'name': product.name,
      'category': product.category,
      'image': product.image,
      'price': product.price,
      'sizes': product.sizes.join(','), // Join sizes list into a string
      'colors': product.colors
          .map((color) => color.value.toRadixString(16))
          .join(','), // Convert colors to hex
      'rating': product.rating,
      'isLiked': product.isLiked ? 1 : 0,
      'isSelected': product.isSelected ? 1 : 0,
    });
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Products');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        category: maps[i]['category'] as String,
        image: maps[i]['image'] as String,
        price: maps[i]['price'] as double,
        sizes: (maps[i]['sizes'] as String)
            .split(','), // Split the string into a list
        colors: (maps[i]['colors'] as String)
            .split(',')
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList(), // Convert hex back to Color
        rating: maps[i]['rating'] as double,
        isLiked: maps[i]['isLiked'] == 1,
        isSelected: maps[i]['isSelected'] == 1,
      );
    });
  }

  // CRUD operations for Categories
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('Categories', {
      'name': category.name,
      'image': category.image,
      'isSelected': category.isSelected ? 1 : 0,
    });
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Categories');

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        image: maps[i]['image'] as String,
        isSelected: maps[i]['isSelected'] == 1,
      );
    });
  }

  // Additional helper methods for updating and deleting records can be added as needed.
}
