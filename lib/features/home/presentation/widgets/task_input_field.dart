import 'package:flutter/material.dart';

class TaskInputField extends StatefulWidget {
  const TaskInputField({super.key});

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isEmpty) return;

    // Handle task submission (to be implemented with business logic)
    final taskText = _controller.text.trim();
    print('Task submitted: $taskText');

    // Clear the input field
    _controller.clear();

    // Optional: Keep focus for quick entry
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Add a new task...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleSubmit(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _handleSubmit,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
