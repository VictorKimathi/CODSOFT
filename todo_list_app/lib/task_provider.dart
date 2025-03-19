import 'package:flutter/material.dart';
import 'task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final String _apiKey = "AIzaSyAsSBFl5RZFvRPkmYZhG09BPyjb8tcMfWM"; // Your valid API key
  late GenerativeModel _model;
  String _productivityInsight = "No tasks yet—start adding some!";

  List<Task> get tasks => _tasks;
  String get productivityInsight => _productivityInsight;

  TaskProvider() {
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey);
    loadTasks();
  }

  Future<void> addTask(Task task) async {
    try {
      print('Starting to add task: ${task.title}');
      task.priority = await _assignPriority(task);
      print('Priority assigned: ${task.priority}');
      task.category = await _categorizeTask(task);
      print('Category assigned: ${task.category}');
      _tasks.add(task);
      print('Task added to list: ${task.title}, Total tasks: ${_tasks.length}');
      await saveTasks();
      print('Tasks saved after adding');
      await _updateProductivityInsights();
      print('Productivity insights updated');
      notifyListeners();
      print('Listeners notified');
    } catch (e) {
      print('Error in addTask: $e');
      // Add task even if AI fails, with fallbacks
      task.priority = 'Medium';
      task.category = 'Uncategorized';
      _tasks.add(task);
      await saveTasks();
      await _updateProductivityInsights();
      notifyListeners();
    }
  }

  Future<void> editTask(String id, String newTitle, String newDescription, DateTime newDueDate) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex >= 0) {
        _tasks[taskIndex].title = newTitle;
        _tasks[taskIndex].description = newDescription;
        _tasks[taskIndex].dueDate = newDueDate;
        _tasks[taskIndex].priority = await _assignPriority(_tasks[taskIndex]);
        _tasks[taskIndex].category = await _categorizeTask(_tasks[taskIndex]);
        await saveTasks();
        await _updateProductivityInsights();
        notifyListeners();
      }
    } catch (e) {
      print('Error in editTask: $e');
    }
  }

  void toggleTaskCompletion(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      saveTasks();
      _updateProductivityInsights();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    _updateProductivityInsights();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList('tasks', taskList);
      print('Tasks saved to SharedPreferences: ${taskList.length} tasks');
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskList = prefs.getStringList('tasks') ?? [];
      _tasks = taskList.map((task) => Task.fromJson(jsonDecode(task))).toList();
      print('Tasks loaded from SharedPreferences: ${_tasks.length} tasks');
      await _updateProductivityInsights();
      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<String> _assignPriority(Task task) async {
    final prompt =
        "Given a task titled '${task.title}' with description '${task.description}' and due date '${task.dueDate.toIso8601String()}', assign a priority level (High, Medium, Low). Respond with only the priority level.";
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? 'Medium';
    } catch (e) {
      print('Error assigning priority: $e');
      return 'Medium';
    }
  }

  Future<String> _categorizeTask(Task task) async {
    final prompt =
        "Given a task titled '${task.title}' with description '${task.description}', categorize it into one of these categories: Work, Personal, Fitness, Shopping, Learning, Other. Respond with only the category name.";
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? 'Uncategorized';
    } catch (e) {
      print('Error categorizing task: $e');
      return 'Uncategorized';
    }
  }

  Future<void> _updateProductivityInsights() async {
    final totalTasks = _tasks.length;
    if (totalTasks == 0) {
      _productivityInsight = "No tasks yet—start adding some!";
    } else {
      final completedTasks = _tasks.where((task) => task.isCompleted).length;
      final workTasks = _tasks.where((task) => task.category == 'Work').length;
      final completedWorkTasks = _tasks.where((task) => task.category == 'Work' && task.isCompleted).length;
      final personalTasks = _tasks.where((task) => task.category == 'Personal').length;
      final completedPersonalTasks = _tasks.where((task) => task.category == 'Personal' && task.isCompleted).length;

      final prompt = """
      Analyze this task data:
      - Total tasks: $totalTasks
      - Completed tasks: $completedTasks
      - Work tasks: $workTasks (Completed: $completedWorkTasks)
      - Personal tasks: $personalTasks (Completed: $completedPersonalTasks)
      Provide a concise productivity insight (1-2 sentences) based on completion rates and category balance.
      """;
      try {
        final response = await _model.generateContent([Content.text(prompt)]);
        _productivityInsight = response.text ?? "Keep pushing your tasks forward!";
      } catch (e) {
        print('Error updating productivity insights: $e');
        _productivityInsight = "Keep pushing your tasks forward!";
      }
    }
    notifyListeners();
  }
}