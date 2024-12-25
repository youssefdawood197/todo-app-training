import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/FireStore/Firestorehandler/FirestoreHandler.dart';
import 'package:todo_app/UI/Login/LoginScreen.dart';
import '../../HomePage/HomePage.dart';
import '../../Reusable/BaseScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/FireStore/User.dart' as MyUser;
import '../../Reusable/LoadingBox.dart';
class Registerscreen extends StatefulWidget {
  static const String routename = "RegisterScreen";

  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print('Starting user registration process...');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const LoadingDialog(message: "Creating Account..."),
        );

        // Register the user
        print('Attempting to create user with email: ${_emailController.text}');
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        print('User registered successfully. UID: ${credential.user!.uid}');

        // Create user document in Firestore
        await FirestoreHandler.createUser(MyUser.User(
          id: credential.user!.uid,
          email: _emailController.text,
          fullName: _nameController.text,
        ));
        print('User document created successfully in Firestore.');

        // Sign in the user automatically
        print('Signing in the user automatically...');
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        print('User signed in successfully.');

        Navigator.of(context).pop();

        // Notify the user about successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Signed in automatically.')),
        );

        // Navigate to the HomePage
        Navigator.pushNamedAndRemoveUntil(context, HomePage.routename, (route) => false);

      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        print('FirebaseAuthException: ${e.code} - ${e.message}');

        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Error'),
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
        Navigator.of(context).pop();
        print('General Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
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
                  "Register",
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                    if (!nameRegex.hasMatch(value)) {
                      return 'Name can only contain letters and spaces';
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
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_confirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
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
                    child: const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routename, (route) => false);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), title: 'Register screen',
    );
  }
}