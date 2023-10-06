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
    String path = join(await getDatabasesPath(), 'my_database1.db');
    return await openDatabase(path, version: 2, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE resep_makanan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_makanan TEXT,
        resep_makanan TEXT
      )
    ''');
  }

  Future<int> insertData(MyData data) async {
    Database db = await database;
    return await db.insert('resep_makanan', data.toMap());
  }

  Future<List<MyData>> getData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('resep_makanan');
    return List.generate(maps.length, (index) {
      return MyData(
        id: maps[index]['id'],
        nama_makanan: maps[index]['nama_makanan'],
        resep_makanan: maps[index]['resep_makanan'],
      );
    });
  }

  Future<int> updateData(MyData data) async {
    Database db = await database;
    return await db.update('resep_makanan', data.toMap(),
        where: 'id = ?', whereArgs: [data.id]);
  }

  Future<int> deleteData(int ?id) async {
    Database db = await database;
    return await db.delete('resep_makanan', where: 'id = ?', whereArgs: [id]);
  }
}
