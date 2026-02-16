import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/presentation/providers/task_provider.dart';
import 'package:todo_list/features/home/presentation/widgets/empty_state_message.dart';
import 'package:todo_list/features/home/presentation/widgets/task_input_field.dart';
import 'package:todo_list/features/home/presentation/widgets/task_list_view.dart';
import 'package:todo_list/features/home/presentation/widgets/task_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 840;
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Watch the task provider state
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            // Dynamic task count from provider
            tasksAsync.when(
              data: (tasks) {
                final taskCount = tasks.length;
                return Text(
                  'You have $taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Filter/Sort button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
              _showFilterOptions(context);
            },
            tooltip: 'Filter tasks',
          ),
          // More options
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show more options
              _showMoreOptions(context, ref);
            },
            tooltip: 'More options',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Responsive max width for better desktop experience
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Task input field
                  const TaskInputField(),
                  const SizedBox(height: 24),
                  // Task list or empty state with loading/error handling
                  Expanded(
                    child: tasksAsync.when(
                      data: (tasks) {
                        return tasks.isEmpty
                            ? const EmptyStateMessage()
                            : const TaskListView();
                      },
                      loading: () => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Loading tasks...',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading tasks',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () {
                                // Retry loading
                                ref.invalidate(taskProvider);
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Show dialog to add new task
          await showTaskDialog(
            context,
            onSave: (task) async {
              await ref.read(taskProvider.notifier).addTask(task);
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  /// Shows filter options bottom sheet
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Tasks',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  title: const Text('All Tasks'),
                  onTap: () {
                    // TODO: Implement filter
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Active Tasks'),
                  onTap: () {
                    // TODO: Implement filter
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.done_all),
                  title: const Text('Completed Tasks'),
                  onTap: () {
                    // TODO: Implement filter
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sort),
                  title: const Text('Sort by Due Date'),
                  onTap: () {
                    // TODO: Implement sort
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.priority_high),
                  title: const Text('Sort by Priority'),
                  onTap: () {
                    // TODO: Implement sort
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows more options menu
  void _showMoreOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More Options',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text('Clear Completed Tasks'),
                  onTap: () async {
                    Navigator.pop(context);
                    
                    // Show confirmation dialog
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Completed Tasks?'),
                        content: const Text(
                          'This will permanently delete all completed tasks.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      final tasks = await ref.read(taskProvider.future);
                      final completedTasks = tasks.where((t) => t.isDone);
                      
                      for (final task in completedTasks) {
                        await ref.read(taskProvider.notifier).deleteTask(task.id);
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () {
                    Navigator.pop(context);
                    ref.invalidate(taskProvider);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'Todo List',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.check_circle_outline),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}