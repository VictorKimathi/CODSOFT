import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Futuristic To-Do List',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 22,
            shadows: [
              Shadow(color: Colors.cyanAccent, blurRadius: 10, offset: Offset(0, 0)),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: Colors.cyanAccent.withOpacity(0.5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                taskProvider.productivityInsight,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 16,
                  fontFamily: 'Orbitron',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet—start adding some!',
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 18,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];
                        return Card(
                          elevation: 4,
                          color: Colors.white.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.cyanAccent),
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontFamily: 'Orbitron',
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Due: ${task.dueDate.toString().substring(0, 10)} | Priority: ${task.priority} | Category: ${task.category}',
                                  style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
                                ),
                              ],
                            ),
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                taskProvider.toggleTaskCompletion(task.id);
                              },
                              activeColor: Colors.cyanAccent,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.black.withOpacity(0.9),
                                    title: const Text(
                                      'Delete Task',
                                      style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete "${task.title}"?',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel', style: TextStyle(color: Colors.cyanAccent)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          taskProvider.deleteTask(task.id);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Task deleted!')),
                                          );
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditTaskScreen(task: task),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTaskScreen(),
            ),
          );
        },
        backgroundColor: Colors.cyanAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}