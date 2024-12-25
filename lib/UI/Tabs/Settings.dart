import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../FireStore/Books.dart';
import '../../FireStore/Firestorehandler/FirestoreHandler.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();

  // Declare controllers for each field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  Future<void> _addbook() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
        return;


      }
      try {
        // Get data from controllers
        String title = _titleController.text;
        String author = _authorController.text;
        int? year_pub = int.tryParse(_yearController.text);
        String genre = _genreController.text;

        // Create a new book instance
        Books newbook = Books(
          title: title,
          author: author,
          year_pub: year_pub,
          genre: genre,
        );

        // Add the book to Firestore
        await FirestoreHandler.addbook(user.uid, newbook);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!')),
        );

        // Clear the text fields after submission
        _titleController.clear();
        _authorController.clear();
        _yearController.clear();
        _genreController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding book: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController, // Assign controller
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorController, // Assign controller
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter an author' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController, // Assign controller
                  decoration: const InputDecoration(
                    labelText: 'Year Published',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genreController, // Assign controller
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a genre' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addbook,
                  child: const Text('Add Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}