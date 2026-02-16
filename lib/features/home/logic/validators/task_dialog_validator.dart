import 'package:flutter/material.dart';

/// Validates the task title in real-time
void validateTitle(
  TextEditingController titleController,
  String? titleError,
  void Function(void Function()) setState,
) {
  final text = titleController.text.trim();
  setState(() {
    if (text.isEmpty && titleError == null) {
      // Don't show error until user tries to save
      titleError = null;
    } else if (text.isEmpty) {
      titleError = 'Task title is required';
    } else if (text.length > 100) {
      titleError = 'Title must be less than 100 characters';
    } else {
      titleError = null;
    }
  });
}

/// Validates all fields before saving
bool validateForm(
  TextEditingController titleController,
  String? titleError,
  void Function(void Function()) setState,
) {
  final title = titleController.text.trim();

  if (title.isEmpty) {
    setState(() => titleError = 'Task title is required');
    return false;
  }

  if (title.length > 100) {
    setState(() => titleError = 'Title must be less than 100 characters');
    return false;
  }

  return true;
}
