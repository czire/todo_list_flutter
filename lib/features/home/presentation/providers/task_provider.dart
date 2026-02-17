import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/data/models/task.dart';
import 'package:todo_list/features/home/logic/repositories/task_local_repository.dart';
import 'package:todo_list/features/home/presentation/providers/services_provider.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final TaskLocalRepository repository;

  // ---------------- Lifecycle ----------------
  @override
  Future<List<Task>> build() async {
    repository = ref.watch(tasksRepositoryProvider);

    var tasks = await repository.getTasks();

    // Seed with mock data if empty
    if (tasks.isEmpty) {
      for (final task in _getMockTasks()) {
        await repository.addTask(task);
      }
      tasks = await repository.getTasks();
    }

    state = AsyncValue.data(tasks);
    return tasks;
  }

  // ---------------- CRUD ----------------
  Future<void> addTask(Task task) async {
    _validateTask(task);
    _ensureUniqueId(task);
    await repository.addTask(task);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    _validateTask(updatedTask);
    await getTask(id); // ensure exists
    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> deleteTask(String id) async {
    if (id.isEmpty) throw ValidationException('Task ID cannot be empty');
    await repository.deleteTask(id);
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<void> deleteCompletedTasks() async {
    final tasks = await repository.getTasks();
    for (final task in tasks.where((t) => t.isDone)) {
      await repository.deleteTask(task.id);
    }
    state = AsyncValue.data(await repository.getTasks());
  }

  Future<Task> getTask(String id) async {
    final tasks = await repository.getTasks();
    return tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw TaskNotFoundException('Task with id $id not found'),
    );
  }

  Future<void> saveTask(Task task) async {
    _validateTask(task);
    final exists = (await repository.getTasks()).any((t) => t.id == task.id);
    exists ? await updateTask(task.id, task) : await addTask(task);
  }

  Future<void> refreshTasks() async {
    state = const AsyncValue.loading();
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

  Future<void> toggleTaskCompletion(String id) async {
    final task = await getTask(id);
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.getTasks());
  }

  // ---------------- Filters ----------------
  Future<void> getTasksByCategory(String category) async {
    state = const AsyncValue.loading();
    final tasks = await repository.getTasks();
    state = AsyncValue.data(
      tasks.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList(),
    );
  }

  Future<void> getTasksByCompletion(bool isDone) async {
    state = const AsyncValue.loading();
    final tasks = await repository.getTasks();
    state = AsyncValue.data(tasks.where((t) => t.isDone == isDone).toList());
  }

  // ---------------- Sorting ----------------
  Future<void> sortTasks(Comparator<Task> comparator) async {
    final tasks = await repository.getTasks();
    tasks.sort(comparator);
    state = AsyncValue.data(tasks);
  }

  Future<void> sortByDueDate() async {
    await sortTasks((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  Future<void> sortByPriority() async {
    await sortTasks((a, b) => b.priority.compareTo(a.priority));
  }

  // ---------------- Validation ----------------
  void _validateTask(Task task) {
    final title = task.title.trim();
    if (title.isEmpty) throw ValidationException('Task title is required');
    if (title.length > 100) throw ValidationException('Task title must be less than 100 characters');

    if (task.category.isEmpty) throw ValidationException('Category is required');
    if (task.priority < 1 || task.priority > 3) {
      throw ValidationException('Priority must be between 1 (Low) and 3 (High)');
    }

    if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
      throw ValidationException('Due date cannot be in the past');
    }
  }

  void _ensureUniqueId(Task task) {
    if (task.id.isEmpty) throw ValidationException('Task must have a valid ID');
  }

  // ---------------- Mock Data ----------------
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

// Provider
final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  () => TaskNotifier(),
);

// Exceptions
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}

class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);
  @override
  String toString() => message;
}