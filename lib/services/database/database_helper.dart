import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "kpu_database.db";
  static const _databaseVersion = 1;

  static const table = 'voters';

  static const columnId = 'id';
  static const columnNIK = 'nik';
  static const columnName = 'name';
  static const columnPhone = 'phone';
  static const columnGender = 'gender';
  static const columnRegistrationDate = 'registrationDate';
  static const columnAddress = 'address';
  static const columnImagePath = 'imagePath';
  static const columnLatitude = 'latitude';
  static const columnLongitude = 'longitude';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('Creating database table...');
    try {
      await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNIK TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnPhone TEXT NOT NULL,
        $columnGender TEXT NOT NULL,
        $columnRegistrationDate TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnImagePath TEXT,
        $columnLatitude REAL,
        $columnLongitude REAL
      )
      ''');
      print('Table created successfully');
    } catch (e) {
      print('Error creating table: $e');
      rethrow;
    }
  }
}
