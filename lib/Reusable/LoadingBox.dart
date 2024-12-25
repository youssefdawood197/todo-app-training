import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Calculate 10% of the screen height
    final double dialogHeight = MediaQuery.of(context).size.height * 0.1;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        height: dialogHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}