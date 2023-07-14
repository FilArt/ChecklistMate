import 'package:uuid/uuid.dart';

class ChecklistItem {
  String? id;
  final String checklistId;
  final String title;
  bool isDone;

  ChecklistItem(
      {required this.checklistId, required this.title, this.isDone = false}) {
    id ??= const Uuid().v4();
  }
}
