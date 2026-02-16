import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/home/data/models/task.dart';

class TaskLocalDataSource {
  final Box<Task> todoBox;

  TaskLocalDataSource(this.todoBox);

  Future<void> addTask(Task task) async {
    await todoBox.put(task.id, task);
  }

  Future<List<Task>> getTasks() async {
    return todoBox.values.toList();
  }

  Future<void> updateTask(Task task) async {
    await todoBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await todoBox.delete(id);
  }
}
