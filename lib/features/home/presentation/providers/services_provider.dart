import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/home/data/datasources/task_local_datasource.dart';
import 'package:todo_list/features/home/data/models/task.dart';
import 'package:todo_list/features/home/logic/repositories/task_local_repository.dart';
import 'package:todo_list/features/home/presentation/providers/task_provider.dart';

final tasksBoxProvider = Provider<Box<Task>>((ref) {
  try {
    return Hive.box<Task>('tasks');
  } catch (e) {
    throw Exception('Failed to open tasks box: $e');
  }
});

final tasksRepositoryProvider = Provider<TaskLocalRepository>((ref) {
  final box = ref.watch(tasksBoxProvider);
  return TaskLocalRepository(TaskLocalDataSource(box));
});

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(() {
  return TaskNotifier();
});
