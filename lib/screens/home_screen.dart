import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _dialogController = TextEditingController();

  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }

//Алерт для добавления новой задачи
  void _showAddTaskDialog(TaskProvider provider) {
    _dialogController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(
          controller: _dialogController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите текст задачи',
          ),
          onSubmitted: (_) => _addAndClose(provider),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => _addAndClose(provider),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _addAndClose(TaskProvider provider) {
    final text = _dialogController.text.trim();
    if (text.isNotEmpty) {
      provider.addTask(text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
        actions: [
          PopupMenuButton<FilterType>(
            onSelected: provider.setFilter,
            icon: const Icon(Icons.filter_list),
            itemBuilder: (_) => const [
              PopupMenuItem(value: FilterType.all, child: Text('Все')),
              PopupMenuItem(
                  value: FilterType.completed, child: Text('Выполненные')),
              PopupMenuItem(
                  value: FilterType.active, child: Text('Невыполненные')),
            ],
          ),
        ],
      ),
      body: provider.tasks.isEmpty
          ? const Center(child: Text('Нет задач'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.tasks.length,
              itemBuilder: (context, i) {
                final task = provider.tasks[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => provider.toggleTask(task),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.removeTask(task),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context.read<TaskProvider>()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
