import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(
                taskId: '',
                title: '',
                description: '',
                isCompleted: false,
              ),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              DateTime? dueDate;
              if (doc['dueDate'] != null) {
                dueDate = (doc['dueDate'] as Timestamp).toDate();
              }

              return Card(
                child: ListTile(
                  title: Text(doc['title'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc['description'] ?? ''),
                      const SizedBox(height: 5),
                      Text(
                        dueDate != null
                            ? 'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'
                            : 'No due date',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  leading: Checkbox(
                    value: doc['isCompleted'] ?? false,
                    onChanged: (value) {
                      if (value == null) return;
                      firestoreService.updateTask(doc.id, {'isCompleted': value});
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      firestoreService.deleteTask(doc.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskScreen(
                          taskId: doc.id,
                          title: doc['title'] ?? '',
                          description: doc['description'] ?? '',
                          isCompleted: doc['isCompleted'] ?? false,
                          dueDate: dueDate,
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
