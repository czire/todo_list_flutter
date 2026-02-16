import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  int priority; // 0=low,1=medium,2=high

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  String category;

  @HiveField(6)
  String? categoryColorHex; // ✅ store as hex string

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.priority = 1,
    this.dueDate,
    this.category = 'General',
    Color? categoryColor,
  }) : categoryColorHex = categoryColor?.value.toRadixString(16);

  Color? get categoryColor => categoryColorHex != null
      ? Color(int.parse(categoryColorHex!, radix: 16))
      : null;

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    int? priority,
    DateTime? dueDate,
    String? category,
    Color? categoryColor,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'categoryColorHex': categoryColorHex,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
      priority: json['priority'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      category: json['category'],
      categoryColor: json['categoryColorHex'] != null
          ? Color(int.parse(json['categoryColorHex'], radix: 16))
          : null,
    );
  }
}
