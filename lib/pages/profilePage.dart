import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config/backButton.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  ///Current Logged In User
  User? currentUser = FirebaseAuth.instance.currentUser;

  ///Fetch User Details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            //Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //Error
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            //Data recived
            else if (snapshot.hasData) {
              //Extract Data
              Map<String, dynamic>? user = snapshot.data?.data();

              return Center(
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(
                          top: 50.0,
                          left: 25
                        ),
                      child: Row(
                        children: [
                          backButton(),
                        ],
                      ),
                    ),


                    //Profile Pic Decorations
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user!['username'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user!['email'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              );
            } else {
              return const Text("No Data");
            }
          }),
    );
  }
}
