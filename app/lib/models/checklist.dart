class Checklist {
  final int id;
  final String title;

  Checklist({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      id: map['id'],
      title: map['title'],
    );
  }
}
