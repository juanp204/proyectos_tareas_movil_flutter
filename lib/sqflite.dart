import 'dart:async';
import 'package:cadena/articulos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper{

  static final SQLHelper instance = SQLHelper._init();

  static Database? _database;

  SQLHelper._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('productos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async{
    await db.execute('''
      CREATE TABLE productos(
        id INTEGER PRIMARY KEY,
        articulo VARCHAR(50)
      )
''');
  }

  Future<void> insert(Articulos articulo) async{
    final db = await instance.database;
    await db.insert("productos", articulo.toMap());
  }
}