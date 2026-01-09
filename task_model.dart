class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
    };
  }
}
