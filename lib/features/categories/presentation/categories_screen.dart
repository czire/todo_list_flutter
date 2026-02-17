import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_list/core/widgets/note_message.dart';

// TODO: Put real
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Mock categories for UI demonstration
    final categories = [
      {
        'name': 'Work',
        'icon': Icons.work_outline,
        'taskCount': 5,
        'color': Colors.blue,
      },
      {
        'name': 'Personal',
        'icon': Icons.person_outline,
        'taskCount': 3,
        'color': Colors.green,
      },
      {
        'name': 'Shopping',
        'icon': Icons.shopping_cart_outlined,
        'taskCount': 2,
        'color': Colors.orange,
      },
      {
        'name': 'Health',
        'icon': Icons.favorite_outline,
        'taskCount': 1,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${categories.length} categories',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new category
            },
            tooltip: 'Add category',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
            tooltip: 'More options',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1000 : double.infinity,
            ),
            child: CustomScrollView(
              slivers: [
                
                SliverToBoxAdapter(
                  child: NoteMessage(
                    message: "NOTE: These are just mock datas",
                  ),
                ),
                // Filter and sort section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 32 : (isTablet ? 24 : 16),
                      16,
                      isDesktop ? 32 : (isTablet ? 24 : 16),
                      8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'all',
                                label: Text('All'),
                                icon: Icon(Icons.apps),
                              ),
                              ButtonSegment(
                                value: 'active',
                                label: Text('Active'),
                                icon: Icon(Icons.check_circle_outline),
                              ),
                              ButtonSegment(
                                value: 'completed',
                                label: Text('Completed'),
                                icon: Icon(Icons.done_all),
                              ),
                            ],
                            selected: const {'all'},
                            onSelectionChanged: (Set<String> selected) {
                              // Handle filter change
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Category cards grid
                if (isDesktop || isTablet)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 24,
                      vertical: 8,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 2 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 2.5 : 2,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = categories[index];
                        return _CategoryCard(
                          name: category['name'] as String,
                          icon: category['icon'] as IconData,
                          taskCount: category['taskCount'] as int,
                          color: category['color'] as Color,
                        );
                      }, childCount: categories.length),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CategoryCard(
                            name: category['name'] as String,
                            icon: category['icon'] as IconData,
                            taskCount: category['taskCount'] as int,
                            color: category['color'] as Color,
                          ),
                        );
                      }, childCount: categories.length),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int taskCount;
  final Color color;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.taskCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to category detail
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
