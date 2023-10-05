import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uts_crud_flutter/model/mydata.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertData(MyData data) async {
    Database db = await database;
    return await db.insert('my_table', data.toMap());
  }

  Future<List<MyData>> getData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('my_table');
    return List.generate(maps.length, (index) {
      return MyData(
        id: maps[index]['id'],
        name: maps[index]['name'],
        email: maps[index]['email'],
      );
    });
  }

  Future<int> updateData(MyData data) async {
    Database db = await database;
    return await db.update('my_table', data.toMap(),
        where: 'id = ?', whereArgs: [data.id]);
  }

  Future<int> deleteData(int id) async {
    Database db = await database;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }
}
