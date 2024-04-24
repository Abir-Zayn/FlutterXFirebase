import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appRoutes.dart';

class appDrawer extends StatelessWidget {
  const appDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
    print("Logged Out");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Row(
                  children: [
                    Icon(Icons.ac_unit_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Flutter x Firebase'),
                  ],
                ),
              ),

              ///For Home page
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("H O M E"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              ///For Profile page
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("P R O F I L E"),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profilePage);
                  },
                ),
              ),
            ],
          ),

          ///Logout tile
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("L O G O U T"),
              onTap: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
