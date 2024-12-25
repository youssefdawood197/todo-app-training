import 'package:flutter/material.dart';
import '../../FireStore/Firestorehandler/FirestoreHandler.dart';
import '../../FireStore/Tasks.dart';
import '../../Reusable/todo_item_card.dart';

class TaskList extends StatelessWidget {
  final String userId;
  const TaskList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: FirestoreHandler.getUserTasks(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return const Center(child: Text('No tasks found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TodoItemCard(
              title: task.title ?? "No Title",
              description: task.description ?? "No Description",
              onComplete: () {}, // Non-functional for now
              onDelete: () {},   // Non-functional for now
              onEdit: () {},     // Non-functional for now
            );
          },
        );
      },
    );
  }
}