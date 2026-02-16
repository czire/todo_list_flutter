import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/data/models/task.dart';
import 'package:todo_list/features/home/presentation/providers/task_provider.dart';
import 'package:todo_list/features/home/presentation/widgets/task_dialog.dart';
import 'package:todo_list/features/home/presentation/widgets/task_item_card.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _handleTaskToggle(String id) {
    ref.read(taskProvider.notifier).toggleTaskCompletion(id);
  }

  void _handleTaskEdit(String id, int index) async {
    final task = await ref.read(taskProvider.notifier).getTask(id);

    await showTaskDialog(
      context,
      existingTask: task,
      onSave: (updatedTask) async {
        await ref.read(taskProvider.notifier).updateTask(id, updatedTask);
      },
    );
  }

  void _handleTaskDelete(String id, int index) async {
    // Show confirmation dialog before deletion
    final shouldDelete = await _showConfirmDeleteDialog(
      context,
      taskTitle: (await ref.read(taskProvider.notifier).getTask(id)).title,
    );

    if (shouldDelete != true) return;

    final removedTask = await ref.read(taskProvider.notifier).getTask(id);

    await ref.read(taskProvider.notifier).deleteTask(id);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildTaskItem(context, removedTask, index, animation),
      duration: const Duration(milliseconds: 300),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${removedTask.title}" deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await ref.read(taskProvider.notifier).addTask(removedTask);

            // ✅ FIX: Get current list length and insert at the end
            // This avoids index out of bounds errors when multiple tasks are deleted
            final currentTasks = ref.read(taskProvider).value ?? [];
            final insertIndex = currentTasks.length - 1;
            
            _listKey.currentState?.insertItem(
              insertIndex,
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    Task task,
    int index,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TaskItemCard(
            task: task,
            onToggle: () => _handleTaskToggle(task.id),
            onEdit: () => _handleTaskEdit(task.id, index),
            onDelete: () => _handleTaskDelete(task.id, index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncTasks = ref.watch(taskProvider);

    return asyncTasks.when(
      data: (tasks) => AnimatedList(
        key: _listKey,
        initialItemCount: tasks.length,
        itemBuilder: (context, index, animation) {
          if (index >= tasks.length) return const SizedBox.shrink();
          return _buildTaskItem(context, tasks[index], index, animation);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

Future<bool?> _showConfirmDeleteDialog(
  BuildContext context, {
  required String taskTitle,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete "$taskTitle"? '
          'This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}