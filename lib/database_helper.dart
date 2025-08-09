import 'package:path/path.dart' as data;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB('cbdb.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = data.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ref TEXT NOT NULL,
        status TEXT NOT NULL,
        image TEXT NOT NULL,
        link TEXT NOT NULL,
        nbredepages TEXT NOT NULL,
        total TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertOrder({
    required String ref,
    String status = 'N/A',
    String? image = 'N/A',
    String? link = 'N/A',
    String? nbreDePages = 'N/A',
    String? total = 'N/A',
    String? date = 'N/A',
  }) async {
    final db = await instance.database;
    return await db.insert('orders', {
      'ref': ref,
      'status': status,
      'image': image,
      'link': link,
      'nbredepages': nbreDePages,
      'total': total,
      'date': date,
    });
  }

  Future<int> deleteOrder(String ref) async {
    final db = await instance.database;
    return await db.delete('orders', where: 'ref = ?', whereArgs: [ref]);
  }
}
