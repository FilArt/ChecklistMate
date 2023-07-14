import 'package:uuid/uuid.dart';

class Checklist {
  String? id;
  final String title;

  Checklist({required this.title}) {
    id ??= const Uuid().v4();
  }
}
