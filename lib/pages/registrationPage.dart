import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x_firebase/config/appTextFormField.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../config/appRoutes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  void registerUser() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //make sure password match
    if (u_passwordController.text != u_confirmPasswordController.text) {
      //pop the loading circle
      Navigator.pop(context);
    } else {
      ///try to create the user
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: u_emailController.text,
                password: u_passwordController.text);

        /// Create a user document and add to firestore
        createUserDocument(userCredential);

        //pop the loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //show error message in a snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    }
  }

  ///Create a user document and collect them in Firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        "username": u_nameController.text,
        "email": u_emailController.text
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
//TextController
  final u_nameController = TextEditingController();
  final u_emailController = TextEditingController();
  final u_passwordController = TextEditingController();
  final u_confirmPasswordController = TextEditingController();

//validity Check
  String? usernameValidator(String value) {
    if (value.isEmpty) {
      return "Username cannot be empty";
    }
    // Add more specific validation rules here
    return null;
  }

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

  String? confirmPasswordValidator(String value) {
    if (value.isEmpty) {
      return "Confirm Password cannot be empty";
    }
    if (value != u_passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: GlassContainer(
            height: double.infinity,
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
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30.0),

                        //User Name Field
                        AppTextFormField(
                          hint: "Username",
                          controller: u_nameController,
                          validator: (value) => usernameValidator(value!),
                        ),

                        const SizedBox(height: 30.0),

                        // Email Address field
                        AppTextFormField(
                          hint: "Email Address",
                          controller: u_emailController,
                          validator: (value) => emailValidator(value!),
                        ),
                        const SizedBox(height: 30.0),

                        // Password field
                        AppTextFormField(
                            hint: "Password",
                            validator: (value) => passwordValidator(value!),
                            controller: u_passwordController),

                        const SizedBox(
                          height: 30,
                        ),

                        //confirm password field
                        AppTextFormField(
                            hint: "Confirm Password",
                            validator: (value) =>
                                confirmPasswordValidator(value!),
                            controller: u_confirmPasswordController),

                        const SizedBox(
                          height: 30,
                        ),

                        const SizedBox(height: 50.0),

                        // Register button
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerUser();
                              } else {
                                print("Form is not valid");
                              }
                              // Navigator.of(context).pushReplacementNamed(AppRoutes.main);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // Text divider or Row with social login buttons
                        const Text(
                          'or sign up with',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.alternate_email_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                child: const Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Login text
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to login screen
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.login);
                              },
                              child: const Text(
                                'Login',
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
