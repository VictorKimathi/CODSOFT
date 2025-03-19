import 'package:flutter/material.dart';
import 'task.dart';
import 'task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.cyanAccent,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate && _isMounted) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(fontFamily: 'Orbitron'),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.cyanAccent),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.cyanAccent),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Due Date: ',
                    style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
                  ),
                  TextButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_dueDate),
                      style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isNotEmpty && _isMounted) {
                    try {
                      if (widget.task == null) {
                        final newTask = Task(
                          id: DateTime.now().toString(),
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dueDate: _dueDate,
                        );
                        await taskProvider.addTask(newTask);
                        print('Add task completed');
                      } else {
                        await taskProvider.editTask(
                          widget.task!.id,
                          _titleController.text,
                          _descriptionController.text,
                          _dueDate,
                        );
                        print('Edit task completed');
                      }
                      if (_isMounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print('Error saving task: $e');
                      if (_isMounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  } else if (_isMounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Title cannot be empty!')),
                    );
                  }
                },
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}