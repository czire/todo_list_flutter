import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/data/models/task.dart';
import 'package:todo_list/features/home/logic/repositories/task_local_repository.dart';
import 'package:todo_list/features/home/presentation/providers/services_provider.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final TaskLocalRepository repository;

  @override
  Future<List<Task>> build() async {
    repository = ref.watch(tasksRepositoryProvider);

    // Load tasks from Hive
    var tasks = await repository.getTasks();

    // If empty, seed with mock data (only once)
    if (tasks.isEmpty) {
      final mockTasks = _getMockTasks();

      for (final task in mockTasks) {
        await repository.addTask(task);
      }

      tasks = await repository.getTasks();
    }

    state = AsyncValue.data(tasks);
    return tasks;
  }

  Future<void> saveTask(Task task) async {
    _validateTask(task);

    final existingTasks = await repository.getTasks();
    final exists = existingTasks.any((t) => t.id == task.id);

    if (exists) {
      // Update existing task
      await updateTask(task.id, task);
    } else {
      // Add new task
      await addTask(task);
    }
  }

  Future<Task> getTask(String id) async {
    final tasks = await repository.getTasks();
    return tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw TaskNotFoundException('Task with id $id not found'),
    );
  }

  Future<void> addTask(Task task) async {
    _validateTask(task);
    _ensureUniqueId(task);

    await repository.addTask(task);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> quickAddTask(String title) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
      priority: 1,
      category: 'General',
      categoryColor: Colors.grey,
    );

    await addTask(newTask);
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    _validateTask(updatedTask);

    // Ensure task exists
    await getTask(id);

    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = await getTask(id);
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> deleteTask(String id) async {
    if (id.isEmpty) {
      throw ValidationException('Task ID cannot be empty');
    }

    await repository.deleteTask(id);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> deleteCompletedTasks() async {
    final tasks = await repository.getTasks();
    final completedTasks = tasks.where((t) => t.isDone);

    for (final task in completedTasks) {
      await repository.deleteTask(task.id);
    }

    state = AsyncValue.data(await repository.getTasks());
  }

  void _validateTask(Task task) {
    // Title validation
    if (task.title.trim().isEmpty) {
      throw ValidationException('Task title is required');
    }

    if (task.title.trim().length > 100) {
      throw ValidationException('Task title must be less than 100 characters');
    }

    if (task.title.trim().isEmpty) {
      throw ValidationException('Task title must be at least 1 character');
    }

    // Category validation
    if (task.category.isEmpty) {
      throw ValidationException('Category is required');
    }

    // Priority validation
    if (task.priority < 1 || task.priority > 3) {
      throw ValidationException(
        'Priority must be between 1 (Low) and 3 (High)',
      );
    }

    // Due date validation
    if (task.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );

      if (dueDate.isBefore(today)) {
        throw ValidationException('Due date cannot be in the past');
      }
    }
  }

  void _ensureUniqueId(Task task) {
    if (task.id.isEmpty) {
      throw ValidationException('Task must have a valid ID');
    }
  }

  List<Task> _getMockTasks() {
    return [
      Task(
        id: '1',
        title: 'Complete project proposal',
        isDone: false,
        priority: 2,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        category: 'Work',
        categoryColor: Colors.blue,
      ),
      Task(
        id: '2',
        title: 'Buy groceries for the week',
        isDone: true,
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        category: 'Shopping',
        categoryColor: Colors.orange,
      ),
      Task(
        id: '3',
        title: 'Schedule dentist appointment',
        isDone: false,
        priority: 3,
        dueDate: DateTime.now().add(const Duration(days: 14)),
        category: 'Health',
        categoryColor: Colors.red,
      ),
      Task(
        id: '4',
        title: 'Call mom',
        isDone: false,
        priority: 2,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        category: 'Personal',
        categoryColor: Colors.green,
      ),
      Task(
        id: '5',
        title: 'Prepare presentation slides',
        isDone: false,
        priority: 3,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        category: 'Work',
        categoryColor: Colors.blue,
      ),
    ];
  }
}

// This exposes the TaskNotifier to the rest of the app
final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  () => TaskNotifier(),
);

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a requested task is not found.
class TaskNotFoundException implements Exception {
  final String message;

  TaskNotFoundException(this.message);

  @override
  String toString() => message;
}
