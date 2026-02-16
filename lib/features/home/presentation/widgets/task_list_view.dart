import 'package:flutter/material.dart';
import 'package:todo_list/features/home/presentation/widgets/task_item_card.dart';

// TODO: Integrate with actual task data from the BLoC and handle state changes accordingly
class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Mock task data for UI demonstration
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': 'Complete project proposal',
      'isCompleted': false,
      'category': 'Work',
      'categoryColor': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Buy groceries for the week',
      'isCompleted': true,
      'category': 'Shopping',
      'categoryColor': Colors.orange,
    },
    {
      'id': '3',
      'title': 'Schedule dentist appointment',
      'isCompleted': false,
      'category': 'Health',
      'categoryColor': Colors.red,
    },
    {
      'id': '4',
      'title': 'Call mom',
      'isCompleted': false,
      'category': 'Personal',
      'categoryColor': Colors.green,
    },
    {
      'id': '5',
      'title': 'Prepare presentation slides',
      'isCompleted': false,
      'category': 'Work',
      'categoryColor': Colors.blue,
    },
  ];

  void _handleTaskToggle(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  void _handleTaskDelete(int index) {
    final removedTask = _tasks[index];
    
    setState(() {
      _tasks.removeAt(index);
    });

    // Animate removal
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildTaskItem(
        context,
        removedTask,
        index,
        animation,
      ),
      duration: const Duration(milliseconds: 300),
    );

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${removedTask['title']}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.insert(index, removedTask);
            });
            _listKey.currentState?.insertItem(
              index,
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    Map<String, dynamic> task,
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
            title: task['title'] as String,
            isCompleted: task['isCompleted'] as bool,
            category: task['category'] as String,
            categoryColor: task['categoryColor'] as Color,
            onToggle: () => _handleTaskToggle(index),
            onDelete: () => _handleTaskDelete(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _tasks.length,
      itemBuilder: (context, index, animation) {
        if (index >= _tasks.length) return const SizedBox.shrink();
        return _buildTaskItem(context, _tasks[index], index, animation);
      },
    );
  }
}