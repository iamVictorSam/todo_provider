// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  final String id;
  final String desc;
  final bool completed;

  Todo({String? id, required this.desc, this.completed = false})
      : id = id ?? uuid.v4();

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id && other.desc == desc && other.completed == completed;
  }

  @override
  int get hashCode => id.hashCode ^ desc.hashCode ^ completed.hashCode;

  @override
  String toString() => 'Todo(id: $id, desc: $desc, completed: $completed)';
}

enum Filter {
  all,
  active,
  completed,
}
