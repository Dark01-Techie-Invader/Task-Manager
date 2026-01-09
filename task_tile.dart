import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final VoidCallback onDelete;
  final Function(bool?) onStatusChanged;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.onDelete,
    required this.onStatusChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: onStatusChanged,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration:
            isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
