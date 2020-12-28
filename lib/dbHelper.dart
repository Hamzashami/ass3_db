
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class db_helper {
  static final int completed_mark = 1;
  static final int not_completed_mark = 2;

  static final _databaseName = "MyDatabase";
  static final _databaseVersion = 2;

  static final table = 'tasks';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnStatus = 'status';

  db_helper._my_constructor();
  static final db_helper instance = db_helper._my_constructor();


  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnStatus INTEGER NOT NULL
          )
          ''');
  }


}
