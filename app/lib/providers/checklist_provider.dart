import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/checklist.dart';
import '../models/checklist_item.dart';

class ChecklistProvider extends ChangeNotifier {
  Database? _database;
  Map<int, Checklist> _checklists = {};
  Map<int, ChecklistItem> _items = {};

  String checklistTable = 'Checklists';
  String checklistItemTable = 'ChecklistItems';
  String colId = 'id';
  String colTitle = 'title';
  String colChecklistId = 'checklistId';
  String colIsDone = 'isDone';

  ChecklistProvider() {
    _initDb();
  }

  Future<void> _initDb() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'checklist.db');

    // File file = File(path);
    // await file.delete();

    _database = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 2,
            onCreate: (Database db, int version) async {
              await db.execute('''
        CREATE TABLE $checklistTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTitle TEXT
        )
      ''');
              await db.execute('''
        CREATE TABLE $checklistItemTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colChecklistId INTEGER NOT NULL,
          $colTitle TEXT,
          $colIsDone INTEGER
        )
      ''');
            }));
    loadChecklistsFromDb();
    loadItemsFromDb();
  }

  Map<int, Checklist> get checklists {
    return {..._checklists};
  }

  Map<int, ChecklistItem> get items {
    return {..._items};
  }

  Future<void> addChecklist(String title) async {
    await _database?.insert(checklistTable, {colTitle: title});
    loadChecklistsFromDb();
  }

  Future<void> addItem(String title, int checklistId) async {
    await _database?.insert(
        checklistItemTable, {colTitle: title, colChecklistId: checklistId});
    loadItemsFromDb();
  }

  Future<void> loadChecklistsFromDb() async {
    final List<Map<String, dynamic>> maps =
        await _database?.query(checklistTable) ?? [];
    _checklists = {for (var item in maps) item[colId]: Checklist.fromMap(item)};
    notifyListeners();
  }

  Future<void> loadItemsFromDb() async {
    final List<Map<String, dynamic>> maps =
        await _database?.query(checklistItemTable) ?? [];
    _items = {for (var item in maps) item[colId]: ChecklistItem.fromMap(item)};
    notifyListeners();
  }

  Future<void> updateChecklistItem(int id, Map<String, dynamic> updates) async {
    await _database?.update(
      checklistItemTable,
      updates,
      where: '$colId = ?',
      whereArgs: [id],
    );
    loadItemsFromDb();
  }

  Future<void> removeChecklist(int id) async {
    await _database?.delete(
      checklistTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    loadChecklistsFromDb();
  }

  Future<void> removeChecklistItem(int id) async {
    await _database?.delete(
      checklistItemTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    loadItemsFromDb();
  }
}
