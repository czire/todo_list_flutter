import 'package:todo_list/features/home/data/datasources/task_local_datasource.dart';
import 'package:todo_list/features/home/data/models/task.dart';

class TaskLocalRepository {
  final TaskLocalDataSource localDataSource;

  TaskLocalRepository(this.localDataSource);

  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }

  Future<void> addTask(Task task) async {
    await localDataSource.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }
}
