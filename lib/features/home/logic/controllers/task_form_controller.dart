import 'package:flutter/material.dart';

class TaskFormController extends ChangeNotifier {
  final titleController = TextEditingController();

  String category = 'Work';
  Color categoryColor = Colors.blue;
  int priority = 1;
  DateTime? dueDate;
  bool isSaving = false;

  void selectCategory(String name, Color color) {
    category = name;
    categoryColor = color;
    notifyListeners();
  }

  void setPriority(int value) {
    priority = value;
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    dueDate = date;
    notifyListeners();
  }
}
