class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  String priority; // High, Medium, Low
  String category; // Work, Personal, Fitness, Shopping, etc.

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
    this.priority = 'Medium',
    this.category = 'Uncategorized',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'category': category,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'],
      category: json['category'],
    );
  }
}