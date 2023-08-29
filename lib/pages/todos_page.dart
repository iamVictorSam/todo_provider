import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/models/todo_model.dart';
import 'package:todo_provider/providers/provider.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: <Widget>[
            TodoHeader(),
            CreateTodo(),
            SearchAndFilterTodo(),
            ShowTodos()
          ],
        ),
      )),
    );
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'TODO',
          style: TextStyle(fontSize: 40),
        ),
        Text(
          '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left',
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        )
      ],
    );
  }
}

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: InputDecoration(labelText: 'What to do?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoList>().addTodo(todoDesc);
          newTodoController.clear();
        }
      },
    );
  }
}

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Todos',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(
              Icons.search,
            ),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              context.read<TodoSearch>().setSearchTerm(newSearchTerm);
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        ),
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.active
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(fontSize: 18, color: textColor(context, filter)),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilter>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodos>().state.filteredTodos;

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          onDismissed: (_) {
            context.read<TodoList>().removeTodo(todos[index]);
          },
          confirmDismiss: (_) {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: Text('Are you sure?'),
                    content: Text('Do you really want to delete?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('NO')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('YES')),
                    ],
                  );
                });
          },
          child: TodoItem(todo: todos[index]),
        );
      },
    );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                bool _error = false;
                textEditingController.text = widget.todo.desc;
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      title: Text('Edit Todo'),
                      content: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        decoration: InputDecoration(
                          errorText: _error ? 'Value cannot be empty' : null,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _error = textEditingController.text.isEmpty
                                ? true
                                : false;

                            if (!_error) {
                              context.read<TodoList>().editTodo(
                                  widget.todo.id, textEditingController.text);
                              Navigator.pop(context);
                            }
                          }),
                          child: Text('EDIT'),
                        ),
                      ],
                    );
                  },
                );
              });
        },
        leading: Checkbox(
          value: widget.todo.completed,
          onChanged: (bool? checked) {
            context.read<TodoList>().toggleTodo(widget.todo.id);
          },
        ),
        title: Text(widget.todo.desc));
  }
}
