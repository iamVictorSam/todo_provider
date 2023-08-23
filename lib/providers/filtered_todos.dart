// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todo_provider/models/todo_model.dart';
import 'package:todo_provider/providers/provider.dart';
import 'package:todo_provider/providers/todo_filter.dart';
import 'package:todo_provider/providers/todo_list.dart';
import 'package:todo_provider/providers/todo_search.dart';

class FilteredTodoState extends Equatable {
  final List<Todo> filteredTodos;

  FilteredTodoState({required this.filteredTodos});

  factory FilteredTodoState.initial() {
    return FilteredTodoState(filteredTodos: []);
  }

  @override
  List<Object> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodoState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodoState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }
}

class FilteredTodos with ChangeNotifier {
  // FilteredTodoState _state = FilteredTodoState.initial();
  late FilteredTodoState _state;
  final List<Todo> initialFilteredTodo;

  FilteredTodos({required this.initialFilteredTodo}) {
    _state = FilteredTodoState(filteredTodos: initialFilteredTodo);
  }
  FilteredTodoState get state => _state;

  void update(TodoFilter todoFilter, TodoSearch todoSearch, TodoList todoList) {
    List<Todo> _filteredTodo;

    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodo =
            todoList.state.todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodo =
            todoList.state.todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodo = todoList.state.todos;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodo = _filteredTodo
          .where((Todo todo) => todo.desc.contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(filteredTodos: _filteredTodo);
    notifyListeners();
  }
}
