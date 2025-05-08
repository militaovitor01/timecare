import 'dart:async';
import 'package:timecare/shared/dao/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectionSqliteService {
  ConnectionSqliteService._();

  static final ConnectionSqliteService _instance = ConnectionSqliteService._();
  static const DATABASE_NAME = 'MedAlertDB.db'; // Inclua a extensão .db
  static const DATABASE_VERSION = 1;

  Database? _db;

  static ConnectionSqliteService get instance => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(ConnectionSQL.CREATE_TABLE_REMEDIO);
  }
}
