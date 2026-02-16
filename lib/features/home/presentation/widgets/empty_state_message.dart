import 'package:flutter/material.dart';

class EmptyStateMessage extends StatelessWidget {
  const EmptyStateMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt,
              size: 100,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            'No tasks yet!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            'Add your first task above to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Helpful tips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Card(
              elevation: 1,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Tips',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(
                      icon: Icons.add_circle_outline,
                      text: 'Use the + button or FAB to add tasks quickly',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.category_outlined,
                      text: 'Organize tasks with categories',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.check_circle_outline,
                      text: 'Check off tasks as you complete them',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
