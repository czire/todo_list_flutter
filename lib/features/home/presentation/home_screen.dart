import 'package:flutter/material.dart';
import 'package:todo_list/features/home/presentation/widgets/empty_state_message.dart';
import 'package:todo_list/features/home/presentation/widgets/task_input_field.dart';
import 'package:todo_list/features/home/presentation/widgets/task_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Mock data for UI demonstration
    final taskCount = 5; // Replace with actual task count
    final hasTasks = taskCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Tasks',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (hasTasks)
              Text(
                'You have $taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
            },
            tooltip: 'Filter tasks',
          ),
          // TODO: More options
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show more options
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
                  // Task list or empty state
                  Expanded(
                    child: hasTasks
                        ? const TaskListView()
                        : const EmptyStateMessage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Trigger add task action
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
