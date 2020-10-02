import 'dart:io';
import 'package:sqf_demo/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'UsersData.db';
  static const _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    print(dbPath);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${User.tblUser}(
        ${User.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${User.colName} TEXT NOT NULL,
        ${User.colMobile} TEXT NOT NULL,
        ${User.colEmail} TEXT NOT NULL,
        ${User.colInterest} TEXT NOT NULL,
        ${User.colAddress} TEXT NOT NULL
        )
        ''');
    print("Table is created");
  }

//CRUD Functions//

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(User.tblUser, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//fetch users//
  Future<List<User>> fetchUser() async {
    Database db = await database;
    List<Map> users = await db.query(User.tblUser);
    return users.length == 0 ? [] : users.map((e) => User.fromMap(e)).toList();
  }

//update user//
  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(User.tblUser, user.toMap(),
        where: '${User.colId}=?', whereArgs: [user.id]);
  }

//delete user//
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db
        .delete(User.tblUser, where: '${User.colId}=?', whereArgs: [id]);
  }
}
