import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;

  const AddEditTaskScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.dueDate,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isCompleted = false;
  DateTime? dueDate;
  bool taskSaved = false;

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    isCompleted = widget.isCompleted;
    dueDate = widget.dueDate;
  }

  void saveTask() async {
    final taskData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'isCompleted': isCompleted,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };

    if (widget.taskId.isEmpty) {
      await firestoreService.addTask(taskData);
    } else {
      await firestoreService.updateTask(widget.taskId, taskData);
    }

    setState(() => taskSaved = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId.isEmpty ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(dueDate != null
                      ? 'Due Date: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                      : 'No due date selected'),
                ),
                TextButton(
                  onPressed: pickDueDate,
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: isCompleted,
              onChanged: (value) {
                if (value == null) return;
                setState(() => isCompleted = value);
              },
              title: const Text('Completed'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTask,
              child: Text(widget.taskId.isEmpty ? 'Add Task' : 'Update Task'),
            ),
            const SizedBox(height: 10),
            if (taskSaved)
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('Task Saved! Go Back'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
