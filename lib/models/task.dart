import 'dart:convert';

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  // Сериализация в Map для хранения
  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };

  // Десериализация из Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
    );
  }

  static List<Task> listFromJson(String jsonString) {
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((e) => Task.fromJson(e)).toList();
  }

  static String listToJson(List<Task> tasks) {
    final List<Map<String, dynamic>> mapped =
        tasks.map((t) => t.toJson()).toList();
    return json.encode(mapped);
  }
}
