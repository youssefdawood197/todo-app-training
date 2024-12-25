import 'package:flutter/material.dart';
import 'package:todo_app/HomePage/HomePage.dart';
import 'package:todo_app/UI/Register/RegisterScreen.dart';
import 'package:todo_app/UI/Login/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'Style/AppTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.LightTheme,
      // Determine initial route based on auth state
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginScreen.routename
          : HomePage.routename,
      routes: {
        Registerscreen.routename: (_) => AuthRedirect(child: Registerscreen()),
        LoginScreen.routename: (_) => AuthRedirect(child: LoginScreen()),
        HomePage.routename: (_) => AuthGuard(child: HomePage()),
      },
    );
  }
}

// AuthGuard for protecting access to HomePage
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routename);
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return child;
    }
  }
}

// AuthRedirect for redirecting to HomePage if the user is already signed in
class AuthRedirect extends StatelessWidget {
  final Widget child;

  const AuthRedirect({required this.child, super.key});
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(HomePage.routename);
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return child;
    }
  }
}