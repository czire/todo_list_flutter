import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/home/presentation/providers/task_provider.dart';

class TaskInputField extends ConsumerStatefulWidget {
  const TaskInputField({super.key});

  @override
  ConsumerState<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends ConsumerState<TaskInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Task title cannot be empty');
      return;
    }

    await ref.read(taskProvider.notifier).quickAddTask(text);

    _controller.clear();
    _errorText = null;
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;

    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                  errorText: _errorText,
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
