import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      debugPrint('Returning existing database');
      return _database!;
    }
    debugPrint('Initializing new database');
    _database = await _initDB('fitbyte.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, fileName);
      debugPrint('Database path: $path');

      // Attempt to open database with read-write mode
      final db = await openDatabase(
        path,
        version: 4,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
        onOpen: (db) => debugPrint('Database opened at $path'),
      );

      // Verify database is writable
      await db.rawQuery('PRAGMA user_version');
      debugPrint('Database is writable');
      return db;
    } catch (e) {
      debugPrint('Error initializing database: $e');
      // If read-only or corrupted, delete and retry
      if (e.toString().contains('SQLITE_READONLY')) {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, fileName);
        await deleteDatabase(path);
        debugPrint('Deleted corrupted database at $path');
        return await _initDB(fileName); // Retry
      }
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE user_settings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          nickname TEXT,
          age INTEGER,
          gender TEXT,
          height REAL,
          height_unit TEXT,
          activity_level TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE weight_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          weight REAL,
          date TEXT
        )
      ''');
      debugPrint('Database tables created');
    } catch (e) {
      debugPrint('Error creating tables: $e');
      rethrow;
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    try {
      for (int version = oldVersion + 1; version <= newVersion; version++) {
        if (version == 2) {
          // No-op (previous upgrades removed)
        } else if (version == 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS weight_records (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              weight REAL,
              date TEXT
            )
          ''');
        } else if (version == 4) {
          await db.execute('ALTER TABLE user_settings ADD COLUMN height REAL');
          await db.execute('ALTER TABLE user_settings ADD COLUMN height_unit TEXT');
          await db.execute('ALTER TABLE user_settings ADD COLUMN activity_level TEXT');
        }
      }
      debugPrint('Database upgraded from $oldVersion to $newVersion');
    } catch (e) {
      debugPrint('Error upgrading database: $e');
      rethrow;
    }
  }

  Future<void> setUserSettings({
    required String name,
    required String phone,
    required String nickname,
    required int age,
    required String gender,
    required double height,
    required String activityLevel,
    required String heightUnit,
  }) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> existing = await db.query('user_settings');
      final data = {
        'name': name,
        'phone': phone,
        'nickname': nickname,
        'age': age,
        'gender': gender,
        'height': height,
        'activity_level': activityLevel,
        'height_unit': heightUnit,
      };

      if (existing.isEmpty) {
        await db.insert('user_settings', data);
        debugPrint('Inserted user settings: $data');
      } else {
        await db.update(
          'user_settings',
          data,
          where: 'id = ?',
          whereArgs: [existing[0]['id']],
        );
        debugPrint('Updated user settings: $data');
      }
    } catch (e) {
      debugPrint('Error setting user settings: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserSettings() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query('user_settings');
      debugPrint('Fetched user settings: ${result.isNotEmpty ? result[0] : null}');
      return result.isNotEmpty ? result[0] : null;
    } catch (e) {
      debugPrint('Error fetching user settings: $e');
      return null;
    }
  }

  Future<void> insertWeightRecord(double weight, String date) async {
    final db = await database;
    try {
      await db.insert('weight_records', {
        'weight': weight,
        'date': date,
      });
      debugPrint('Inserted weight record: {weight: $weight, date: $date}');
    } catch (e) {
      debugPrint('Error inserting weight record: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getWeightRecords() async {
    final db = await database;
    try {
      final result = await db.query('weight_records', orderBy: 'date ASC');
      debugPrint('Fetched weight records: $result');
      return result;
    } catch (e) {
      debugPrint('Error fetching weight records: $e');
      return [];
    }
  }

  Future<void> clearAllData() async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete('user_settings');
        await txn.delete('weight_records');
      });
      // Step 3: Reset GetX controllers
Get.delete<CalculatorController>(force: true);
Get.delete<DashboardController>(force: true);
Get.delete<ThemeController>(force: true);
Get.put(CalculatorController());
Get.put(DashboardController());
Get.put(ThemeController());
      debugPrint('All data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing data: $e');
      if (e.toString().contains('SQLITE_READONLY')) {
        // Reinitialize database
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'fitbyte.db');
        await db.close();
        await deleteDatabase(path);
        debugPrint('Deleted read-only database at $path');
        _database = null; // Reset to force reinitialization
        await database; // Reinitialize
        // Retry clearing data
        await db.transaction((txn) async {
          await txn.delete('user_settings');
          await txn.delete('weight_records');
        });
        debugPrint('All data cleared after reinitialization');
      } else {
        rethrow;
      }
    }
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      debugPrint('Database closed');
    }
  }
}