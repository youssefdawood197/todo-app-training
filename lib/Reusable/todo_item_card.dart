import 'package:flutter/material.dart';

class TodoItemCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.onComplete,
    required this.onDelete,
    required this.onEdit,
  });

  void _showDetailsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description.isNotEmpty ? description : 'No description available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsPopup(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.grey),
                  onPressed: null, // Disabled for now
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: null, // Disabled for now
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: null, // Disabled for now
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}