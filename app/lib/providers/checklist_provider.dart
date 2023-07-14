import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../models/checklist_item.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ChecklistProvider extends ChangeNotifier {
  late Box<Checklist>? checklistBox;
  late Box<ChecklistItem> itemBox;

  ChecklistProvider({Box<Checklist>? checklistBox}) {
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    checklistBox = checklistBox ?? await Hive.openBox<Checklist>('checklists');
    itemBox = await Hive.openBox<ChecklistItem>('items');
    notifyListeners();
  }

  List<Checklist> get checklists => checklistBox.values.toList();

  List<ChecklistItem> get items => itemBox.values.toList();

  Future<void> addChecklist(Checklist checklist) async {
    await checklistBox.put(checklist.id, checklist);
    notifyListeners();
  }

  Future<void> addItem(String? checklistId, String? title, bool? isDone) async {
    if (!checklistBox.containsKey(checklistId)) {
      throw Exception('checklist with id=$checklistId not found');
    }
    if (checklistId == null) throw Exception('checklistId cannot be null');

    var item = ChecklistItem(
        checklistId: checklistId, title: title ?? '', isDone: isDone ?? false);
    await itemBox.put(item.id, item);
    notifyListeners();
  }

  Future<void> updateChecklistItem(String? id,
      {String? title, String? checklistId, bool isDone = false}) async {
    if (id == null) return;
    ChecklistItem? checklistItem = itemBox.get(id);
    if (checklistItem == null) throw Exception('not found');
    var newChecklistItem = ChecklistItem(
        checklistId: checklistId ?? checklistItem.checklistId,
        title: title ?? checklistItem.title,
        isDone: isDone);
    await itemBox.put(id, newChecklistItem);
    notifyListeners();
  }

  Future<void> removeChecklist(String? id) async {
    if (id == null) return;
    await checklistBox.delete(id);
    notifyListeners();
  }

  Future<void> removeChecklistItem(String? id) async {
    if (id == null) return;
    await itemBox.delete(id);
    notifyListeners();
  }
}
