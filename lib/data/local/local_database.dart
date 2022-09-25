import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:working_with_location/data/local/cached_address.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;

  factory LocalDatabase() {
    return getInstance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("location.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  LocalDatabase._init();

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";
    const doubleType = "REAL DEFAULT 0.0";

    await db.execute('''
    CREATE TABLE $addressTable (
    ${CachedAddressFields.id} $idType,
    ${CachedAddressFields.addressName} $textType,
    ${CachedAddressFields.addressType} $intType,
    ${CachedAddressFields.createdAt} $textType,
    ${CachedAddressFields.longitude} $doubleType,
    ${CachedAddressFields.latitude} $doubleType
    )
    ''');
  }

  //-------------------------------------------Cached Users Table------------------------------------

  static Future<CachedAddress> insertCachedAddress(
      CachedAddress cachedAddress) async {
    final db = await getInstance.database;
    final id = await db.insert(addressTable, cachedAddress.toJson());
    return cachedAddress.copyWith(id: id);
  }

  static Future<CachedAddress> getSingleAddressById(int id) async {
    final db = await getInstance.database;
    final results = await db.query(
      addressTable,
      columns: CachedAddressFields.values,
      where: '${CachedAddressFields.id} = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return CachedAddress.fromJson(results.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<CachedAddress>> getAllCachedAddresses() async {
    final db = await getInstance.database;
    const orderBy = "${CachedAddressFields.addressName} ASC";
    final result = await db.query(
      addressTable,
      orderBy: orderBy,
    );
    return result.map((json) => CachedAddress.fromJson(json)).toList();
  }

  static Future<int> deleteCachedAddressById(int id) async {
    final db = await getInstance.database;
    var t = await db.delete(addressTable,
        where: "${CachedAddressFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedAddress(CachedAddress cachedAddress) async {
    Map<String, dynamic> row = {
      CachedAddressFields.addressName: cachedAddress.addressName,
      CachedAddressFields.addressType: cachedAddress.addressType,
      CachedAddressFields.createdAt: cachedAddress.createdAt,
      CachedAddressFields.longitude: cachedAddress.longitude,
      CachedAddressFields.latitude: cachedAddress.latitude,
    };

    final db = await getInstance.database;
    return await db.update(
      addressTable,
      row,
      where: '${CachedAddressFields.id} = ?',
      whereArgs: [cachedAddress.id],
    );
  }

  static Future<int> deleteAllCachedAddresses() async {
    final db = await getInstance.database;
    return await db.delete(addressTable);
  }

  Future close() async {
    final db = await getInstance.database;
    db.close();
  }
}
