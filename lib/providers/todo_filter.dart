// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_provider/models/todo_model.dart';

class TodoFilterState {
  final Filter filter;

  TodoFilterState({required this.filter});

  factory TodoFilterState.initial() {
    return TodoFilterState(filter: Filter.all);
  }

  @override
  bool operator ==(covariant TodoFilterState other) {
    if (identical(this, other)) return true;

    return other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;

  @override
  String toString() => 'TodoFilterState(filter: $filter)';

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }
}

class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initial();
}
