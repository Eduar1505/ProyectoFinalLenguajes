// ignore_for_file: prefer_final_fields
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper(){
    return _instance;
  }

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'miagenda.db');
    return await openDatabase(
      path, 
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE tareas(
      nombre TEXT,
      descripcion TEXT,
      fecha TEXT,
      hora TEXT
    )
    ''');
  }

  Future<int> insertarTarea(Map<String, dynamic> tarea) async{
    Database db = await database;
    return await db.insert('tareas', tarea);
  }

  Future<List<Map<String, dynamic>>> obtenerTarea() async{
    Database db = await database;
    return await db.query('tareas');
  }

  Future<int> actualizarTarea(Map<String, dynamic> tarea,) async {
    Database db = await database;
    return await db.update(
      'tareas',
      tarea,
      where: 'id = ?',
      whereArgs: [tarea['id']],
    );
  }

  Future<int> eliminarTarea(int id) async {
    Database db = await database;
    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}