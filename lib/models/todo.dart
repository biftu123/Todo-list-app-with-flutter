// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;
  Todo(
      {required this.task,
      required this.isDone,
      required this.createdOn,
      required this.updatedOn});

  Todo.fromJson(Map<String, Object?> Json)
      : this(
            task: Json['task']! as String,
            isDone: Json['isDone']! as bool,
            createdOn: Json['createdOn']! as Timestamp,
            updatedOn: Json['updatedOn']! as Timestamp);
  Todo copywith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Todo(
        task: task ?? this.task,
        isDone: isDone ?? this.isDone,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
