// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:todo_provider/models/todo_model.dart';

class TodoListState {
  final List<Todo> todos;

  TodoListState({required this.todos});

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: '1', desc: 'Code Flutter'),
      Todo(id: '2', desc: 'Write an Article'),
      Todo(id: '3', desc: 'Merge Skiipe Code'),
    ]);
  }

  @override
  bool operator ==(covariant TodoListState other) {
    if (identical(this, other)) return true;

    return listEquals(other.todos, todos);
  }

  @override
  int get hashCode => todos.hashCode;

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }

  @override
  String toString() => 'TodoListState(todos: $todos)';
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  TodoListState get state => _state;

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodos = [..._state.todos, newTodo];

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }
}
