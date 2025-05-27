import 'dart:async';
import 'package:timecare/shared/dao/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectionSqliteService {
  ConnectionSqliteService._();

  static final ConnectionSqliteService _instance = ConnectionSqliteService._();
  static const DATABASE_NAME = 'MedAlertDB.db'; // Inclua a extensão .db
  static const DATABASE_VERSION =
      3; // Incrementado para forçar recriação do banco

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
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL,
        telefone TEXT,
        endereco TEXT,
        idade INTEGER,
        foto TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE remedios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        dosagem TEXT NOT NULL,
        instrucoes TEXT,
        frequencia INTEGER,
        horario TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Recria a tabela de usuários
      try {
        await db.execute('DROP TABLE IF EXISTS usuarios;');
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL,
            telefone TEXT,
            endereco TEXT,
            idade INTEGER,
            foto TEXT
          )
        ''');
      } catch (e) {
        print('Erro ao recriar tabela usuarios: $e');
      }

      // Atualiza a tabela de remédios
      try {
        await db.execute('ALTER TABLE remedios ADD COLUMN instrucoes TEXT;');
      } catch (e) {
        print('Coluna instrucoes já existe ou erro ao adicionar: $e');
      }
    }
  }

  Future<void> deleteDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);
    await databaseFactory.deleteDatabase(path);
    _db = null;
  }
}
