import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/UI/Tabs/TaskList.dart';
import 'package:todo_app/UI/Tabs/Settings.dart';
import '../Reusable/BaseScaffold.dart';
import '../UI/Custome widgets/AddTaskFormState.dart';

class HomePage extends StatefulWidget {
  static const String routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  /// Sign out the current user and navigate to the login screen
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('LoginScreen');
  }

  /// Show a bottom sheet with the add task form
  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: AddTaskForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Determine the page title based on the selected tab
    final String title = selectedIndex == 0 ? "List" : "Settings";

    // Define tabs dynamically with the user ID for TaskList
    final List<Widget> tabs = [
      TaskList(userId: user?.uid ?? ''),
      const Settings(),
    ];

    return BaseScaffold(
      title: title,
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'User Info',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              if (user != null) ...[
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('Email: ${user.email ?? "No Email"}'),
                ),
                ListTile(
                  leading: const Icon(Icons.perm_identity),
                  title: Text('User ID: ${user.uid}'),
                ),
              ] else ...[
                const ListTile(
                  leading: Icon(Icons.error),
                  title: Text('No user signed in'),
                ),
              ],
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskBottomSheet,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.list,
                  size: 30,
                  color: selectedIndex == 0 ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 30,
                  color: selectedIndex == 1 ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}