import 'package:flutter/material.dart';
import 'package:todo_list/features/home/presentation/widgets/task_item_card.dart';

class CategorySection extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const CategorySection({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Mock tasks for this category
    final categoryTasks = [
      {
        'id': '1',
        'title': 'Sample task in $categoryName',
        'isCompleted': false,
      },
      {
        'id': '2',
        'title': 'Another task here',
        'isCompleted': true,
      },
    ];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          InkWell(
            onTap: () {
              // Navigate to category detail or expand/collapse
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                        ),
                        Text(
                          '${categoryTasks.length} ${categoryTasks.length == 1 ? 'task' : 'tasks'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: categoryColor,
                  ),
                ],
              ),
            ),
          ),
          // Task list
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: categoryTasks.asMap().entries.map((entry) {
                final task = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text("Hello World"),
                  // TaskItemCard(
                  //   title: task['title'] as String,
                  //   isCompleted: task['isCompleted'] as bool,
                  //   category: categoryName,
                  //   categoryColor: categoryColor,
                  //   onToggle: () {
                  //     // Handle task toggle
                  //   },
                  //   onDelete: () {
                  //     // Handle task delete
                  //   },
                  // ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}