import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/UI/Register/RegisterScreen.dart';
import '../../HomePage/HomePage.dart';
import '../../Reusable/BaseScaffold.dart';
import '../../HomePage/HomePage.dart';
import '../../Reusable/LoadingBox.dart';

class LoginScreen extends StatefulWidget {
  static const String routename = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
/*
  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        showDialog(context: context, builder: (context)=> LoadingDialog(message: "Logging in...",));
        // Sign in the user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Notify the user about successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );

        // Navigate to the HomePage after successful login
       // Navigator.pushNamedAndRemoveUntil(context, HomePage.routename, (route)=> false);
      } on FirebaseAuthException catch (e) {
        // Handle specific FirebaseAuth exceptions
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many login attempts. Please try again later.';
        }

        showDialog(context: context, builder: (context)=> LoadingDialog(message: errorMessage,));

        // Show the error message in a SnackBar

      } catch (e) {
        // Handle general errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
      // Notify user to correct form errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }
*/
  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show the loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const LoadingDialog(message: "Logging in..."),
        );

        // Sign in the user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Close the loading dialog
        Navigator.of(context).pop();

        // Notify the user about successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );

        // Navigate to the HomePage after successful login
        Navigator.pushNamedAndRemoveUntil(context, HomePage.routename, (route) => false);

      } on FirebaseAuthException catch (e) {
        // Close the loading dialog before showing the error
        Navigator.of(context).pop();

        // Handle specific FirebaseAuth exceptions
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many login attempts. Please try again later.';
        }

        // Show the error message in an AlertDialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Close the loading dialog before showing a general error
        Navigator.of(context).pop();

        // Show a general error message in an AlertDialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Notify the user to correct form errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the RegisterScreen
                      Navigator.pushNamedAndRemoveUntil(context, Registerscreen.routename, (route) => false);

                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), endDrawer: null, title: 'Login Screen',
    );
  }
}