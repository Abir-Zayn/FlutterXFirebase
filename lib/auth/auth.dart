import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x_firebase/pages/home_page.dart';
import 'package:flutter_x_firebase/pages/loginPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const loginPage();
            }
          }),
    );
  }
}
