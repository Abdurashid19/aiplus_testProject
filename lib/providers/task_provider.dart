import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

enum FilterType { all, completed, active }

class TaskProvider extends ChangeNotifier {
  static const _storageKey = 'tasks';

  List<Task> _tasks = [];
  FilterType _filter = FilterType.all;

  // Возвращает список задач в зависимости от текущего фильтра
  List<Task> get tasks {
    switch (_filter) {
      case FilterType.completed:
        return _tasks.where((t) => t.isDone).toList();
      case FilterType.active:
        return _tasks.where((t) => !t.isDone).toList();
      case FilterType.all:
      default:
        return _tasks;
    }
  }

  // Текущий тип фильтра
  FilterType get filter => _filter;

  // Конструктор
  TaskProvider() {
    _loadFromPrefs();
  }

// Подгружаем список задач из SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      _tasks = Task.listFromJson(jsonString);
      notifyListeners();
    }
  }

  // Сохраняет текущий список задач
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, Task.listToJson(_tasks));
  }

  // Добавляет новую задачу
  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(Task(title: title.trim()));
    _saveToPrefs();
    notifyListeners();
  }

// Переключает статус выполнения задачи
  void toggleTask(Task task) {
    final index = _tasks.indexOf(task);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      _saveToPrefs();
      notifyListeners();
    }
  }

// Удаляет задачу
  void removeTask(Task task) {
    _tasks.remove(task);
    _saveToPrefs();
    notifyListeners();
  }

  void setFilter(FilterType type) {
    _filter = type;
    notifyListeners();
  }
}
