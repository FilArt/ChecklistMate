class ChecklistItem {
  final int id;
  final int checklistId;
  final String title;
  bool isDone;

  ChecklistItem(
      {required this.id,
      required this.checklistId,
      required this.title,
      this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checklistId': checklistId,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'],
      checklistId: map['checklistId'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
