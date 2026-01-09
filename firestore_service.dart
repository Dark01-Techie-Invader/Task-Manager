import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference tasks =
  FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot> getTasks() => tasks.snapshots();

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await tasks.add(taskData);
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> taskData) async {
    await tasks.doc(taskId).update(taskData);
  }

  Future<void> deleteTask(String taskId) async {
    await tasks.doc(taskId).delete();
  }
}
