import 'package:flutter/material.dart';
import 'package:todo_list/features/home/data/constants/task_categories.dart';
import 'package:todo_list/features/home/data/models/task.dart';

/// Shows a Material 3 dialog for adding or editing a task.
Future<void> showTaskDialog(
  BuildContext context, {
  Task? existingTask,
  required Future<void> Function(Task) onSave,
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) =>
        _TaskDialog(existingTask: existingTask, onSave: onSave),
  );
}

class _TaskDialog extends StatefulWidget {
  final Task? existingTask;
  final Future<void> Function(Task) onSave;

  const _TaskDialog({this.existingTask, required this.onSave});

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  late final TextEditingController _titleController;

  String _selectedCategory = 'Work';
  Color _selectedCategoryColor = Colors.blue;
  int _selectedPriority = 1;
  DateTime? _selectedDueDate;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Initialize form with existing task data or defaults
    // This is UI state initialization, not business logic
    _titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );

    if (widget.existingTask != null) {
      _selectedCategory = widget.existingTask!.category;
      _selectedCategoryColor =
          widget.existingTask!.categoryColor ?? Colors.blue;
      _selectedPriority = widget.existingTask!.priority;
      _selectedDueDate = widget.existingTask!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      // Create task object from form data
      final task = Task(
        id:
            widget.existingTask?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        isDone: widget.existingTask?.isDone ?? false,
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        category: _selectedCategory,
        categoryColor: _selectedCategoryColor,
      );

      // Validation and persistence
      await widget.onSave(task);

      // Close dialog on success
      if (mounted) {
        Navigator.of(context).pop();

        _showSuccessSnackBar();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }

  /// Shows success feedback.
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.existingTask == null
              ? 'Task added successfully'
              : 'Task updated successfully',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows error feedback.
  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final dialogWidth = isDesktop ? 600.0 : (isTablet ? 500.0 : null);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),

      // Responsive padding
      contentPadding: EdgeInsets.all(isDesktop ? 24 : 20),

      // Title
      title: Row(
        children: [
          Icon(
            widget.existingTask == null ? Icons.add_task : Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.existingTask == null ? 'Add New Task' : 'Edit Task',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      // Content
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskTitleField(),
              const SizedBox(height: 24),
              _buildCategorySection(),
              const SizedBox(height: 24),
              _buildPrioritySection(),
              const SizedBox(height: 24),
              _buildDueDateSection(),
            ],
          ),
        ),
      ),

      // Actions
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _handleSave,
          icon: _isSaving
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.check),
          label: Text(_isSaving ? 'Saving...' : 'Save'),
        ),
      ],

      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 20,
        0,
        isDesktop ? 24 : 20,
        isDesktop ? 24 : 20,
      ),
    );
  }

  /// Builds the task title input field.
  Widget _buildTaskTitleField() {
    return TextField(
      controller: _titleController,
      autofocus: widget.existingTask == null,
      maxLength: 100,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Task Title *',
        hintText: 'Enter task description',
        helperText: 'Required',
        prefixIcon: Icon(
          Icons.title,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: const OutlineInputBorder(),
        counterText: '${_titleController.text.length}/100',
      ),
      onChanged: (_) {
        // Update counter in real-time (UI feedback only)
        setState(() {});
      },
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category['name'];

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : category['color'] as Color,
                  ),
                  const SizedBox(width: 6),
                  Text(category['name'] as String),
                ],
              ),
              selected: isSelected,
              selectedColor: category['color'] as Color,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category['name'] as String;
                    _selectedCategoryColor = category['color'] as Color;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(
              value: 1,
              label: Text('Low'),
              icon: Icon(Icons.low_priority),
            ),
            ButtonSegment(
              value: 2,
              label: Text('Medium'),
              icon: Icon(Icons.priority_high),
            ),
            ButtonSegment(
              value: 3,
              label: Text('High'),
              icon: Icon(Icons.warning_amber_rounded),
            ),
          ],
          selected: {_selectedPriority},
          onSelectionChanged: (Set<int> selected) {
            setState(() => _selectedPriority = selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: InkWell(
            onTap: _selectDueDate,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedDueDate != null
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: _selectedDueDate != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDueDate != null
                              ? _formatDate(_selectedDueDate!)
                              : 'No due date',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _selectedDueDate != null
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        if (_selectedDueDate != null)
                          Text(
                            _selectedDueDate!.toString().split(' ')[0],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedDueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              setState(() => _selectedDueDate = null),
                          tooltip: 'Clear due date',
                          iconSize: 20,
                        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedDueDate == null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Optional - Tap to set a due date',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
