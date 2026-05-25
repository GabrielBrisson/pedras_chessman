import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/gema.dart';

class GemaDatabase {
  static final GemaDatabase instance = GemaDatabase._init();
  static Database? _database;

  GemaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gemas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gemas (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        cor TEXT NOT NULL,
        carats REAL NOT NULL,
        valorEstimado REAL NOT NULL,
        origem TEXT NOT NULL,
        parentId TEXT,
        FOREIGN KEY (parentId) REFERENCES gemas (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_parentId ON gemas(parentId)');
  }

  Future<void> insert(Gema gema) async {
    final db = await instance.database;
    await db.insert('gemas', gema.toMap());
  }

  Future<void> update(Gema gema) async {
    final db = await instance.database;
    await db.update(
      'gemas',
      gema.toMap(),
      where: 'id = ?',
      whereArgs: [gema.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await instance.database;
    await db.delete(
      'gemas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('gemas');
  }

  Future<List<Gema>> getAll() async {
    final db = await instance.database;
    final result = await db.query('gemas', orderBy: 'nome');
    return result.map((json) => Gema.fromMap(json)).toList();
  }


  Future<List<Gema>> getAllHierarchical() async {
    final db = await instance.database;
    final result = await db.query('gemas', orderBy: 'nome ASC');

    List<Gema> allGemas = result.map((map) => Gema.fromMap(map)).toList();

    Map<String, Gema> gemasMap = {for (var g in allGemas) g.id: g};

    List<Gema> roots = [];

    for (var gema in allGemas) {
      if (gema.parentId == null) {
        roots.add(gema);
      } else if (gemasMap.containsKey(gema.parentId)) {
        gemasMap[gema.parentId]!.filhos.add(gema);
      }
    }

    return roots;
  }

  Future<List<Gema>> getFilhos(String parentId) async {
    final db = await instance.database;
    final result = await db.query(
      'gemas',
      where: 'parentId = ?',
      whereArgs: [parentId],
      orderBy: 'nome',
    );
    return result.map((map) => Gema.fromMap(map)).toList();
  }

  Future<bool> hasFilhos(String id) async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM gemas WHERE parentId = ?',
      [id],
    ));
    return (count ?? 0) > 0;
  }
}