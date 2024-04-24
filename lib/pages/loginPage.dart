import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../config/appRoutes.dart';
import '../config/appTextFormField.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final _formKey = GlobalKey<FormState>();

  ///Text Controller for login
  final u_mailController = TextEditingController();
  final u_passwordController = TextEditingController();

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    }
    final emailRegExp = RegExp(r"^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$");
    if (!emailRegExp.hasMatch(value)) {
      return "Invalid Email Format";
    }
    return null;
  }

  /// Validates the password based on specific rules.
  /// Returns an error message if the password is invalid, otherwise returns null.
  String? passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 6 || value.length > 20) {
      return "Password must be between 6 and 20 characters";
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }

  ///Login Functionality
  void login() async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: u_mailController.text,
        password: u_passwordController.text,
      );

      if (context.mounted) Navigator.pop(context); // Pop the loading circle

      clearTextFields();

      Navigator.of(context).pushNamed(AppRoutes.home); // Navigate to the home screen

    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context); // Pop the loading circle

      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  /// Clears the text fields.
  void clearTextFields() {
    u_mailController.clear();
    u_passwordController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GlassContainer(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            blur: 4,
            color: Colors.white.withOpacity(0.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white70.withOpacity(0.3),
              ],
            ),
            child: Center(
              child: SingleChildScrollView(
                // Wrap the Column
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login Here",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30.0),

                        // Email Address field
                        AppTextFormField(
                          hint: "Email Address",
                          controller: u_mailController,
                          validator: (value) => emailValidator(value!),
                        ),

                        const SizedBox(height: 30),

                        //Password Field
                        AppTextFormField(
                          hint: "Password",
                          controller: u_passwordController,
                          validator: (value) => passwordValidator(value!),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        // Login button
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              } else {
                                print("Error");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),

                        // Add some space before the bottom section
                        Row(
                          // Wrap with Row for proper alignment
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Are you New here?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to login screen
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.register);
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.amberAccent),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
