//The sqlite database operations
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final Future<Database> database = openDatabase(
  join(await getDatabasesPath(), 'smart_shop.db'),
);

