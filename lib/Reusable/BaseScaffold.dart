import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    required this.title,
    required this.body,
    this.endDrawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '', // Provide a fallback empty string if `title` is null
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 4.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                // Open the end drawer
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: endDrawer,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}