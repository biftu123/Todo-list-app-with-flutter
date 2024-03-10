import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/models/todo.dart';
import 'package:intl/intl.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final databaseService _databaseService = databaseService();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 240, 116),
        title: Text("MyToDoList"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: _databaseService.getTodos(),
          builder: (context, snapshot) {
            List todos = snapshot.data?.docs ?? [];
            if (todos.isEmpty) {
              return Center(
                child: Text('Add todo'),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index].data();
                  String todoId = todos[index].id;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      title: Text(todo.task),
                      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(todo.updatedOn.toDate())),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todo updatedTodo = todo.copywith(
                              isDone: !todo.isDone, updatedOn: Timestamp.now());
                          _databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      onLongPress: () {
                        _databaseService.deleteTodo(todoId);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController _textEditingController =
                  TextEditingController();
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text("Add Todo"),
                  ],
                ),
                content: TextField(
                  controller: _textEditingController,
                ),
                actions: [
                  MaterialButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Todo todo = Todo(
                        task: _textEditingController.text,
                        isDone: false,
                        createdOn: Timestamp.now(),
                        updatedOn: Timestamp.now(),
                      );
                      _databaseService.addTodo(todo);
                      Navigator.pop(context);
                      _textEditingController.clear();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add)
      ),
    );
  }
}
