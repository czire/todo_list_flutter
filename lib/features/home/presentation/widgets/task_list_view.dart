import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/data/models/task.dart';
import 'package:todo_list/features/home/presentation/providers/task_provider.dart';
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

  void _handleTaskDelete(String id, int index) async {
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
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(taskProvider.notifier).addTask(removedTask);
            _listKey.currentState?.insertItem(
              index,
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
