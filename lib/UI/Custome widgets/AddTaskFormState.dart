import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/FireStore/Firestorehandler/FirestoreHandler.dart';
import '../../FireStore/Tasks.dart';

class AddTaskForm extends StatefulWidget {
  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}
class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? dueDate;

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current authenticated user's ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
        return;
      }

      try {
        // Create a new task
        Task newTask = Task(
          title: title,
          description: description,
          taskId: '', // Will be assigned by Firestore
        );

        // Add the task to Firestore linked to the user's ID
        await FirestoreHandler.createTask(user.uid, newTask);

        // Notify the user about the successful task creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );

        // Close the bottom sheet or navigate away
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
            onSaved: (value) => title = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onSaved: (value) => description = value ?? '',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                dueDate == null
                    ? 'No due date selected'
                    : 'Due Date: ${dueDate!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _pickDueDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}