import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/equipment_model.dart';

class EquipmentLocalDb {
  static Database? _db;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("SQLite no es compatible con Web");
    }

    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'equipment.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE equipment (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        status TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<void> insertEquipment(Equipment equipment) async {
    if (kIsWeb) return;
    final db = await database;
    await db.insert(
      'equipment',
      {
        'id': equipment.id,
        'name': equipment.name,
        'type': equipment.type,
        'status': equipment.status,
        'createdAt': equipment.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Equipment>> getEquipments() async {
    if (kIsWeb) return [];
    final db = await database;
    final maps = await db.query('equipment');

    return maps.map((map) {
      return Equipment(
        id: map['id'] as String,
        name: map['name'] as String,
        type: map['type'] as String,
        status: map['status'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
    }).toList();
  }

  Future<void> deleteEquipment(String id) async {
    if (kIsWeb) return;
    final db = await database;
    await db.delete('equipment', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    if (kIsWeb) return;
    final db = await database;
    await db.delete('equipment');
  }

  Future<void> replaceAll(List<Equipment> list) async {
    if (kIsWeb) return;
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('equipment');
      for (final item in list) {
        await txn.insert(
          'equipment',
          {
            'id': item.id,
            'name': item.name,
            'type': item.type,
            'status': item.status,
            'createdAt': item.createdAt.toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
