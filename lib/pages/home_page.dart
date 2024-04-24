import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x_firebase/config/appDrawer.dart';

import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Logout Button



  //FireStore
  final firestoreService = FirestoreService();

  //TextController
  final textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //buttons to save
          ElevatedButton(
            onPressed: () {
              //add note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              } else {
                firestoreService.updateNote(docID, textController.text);
              }
              //clear the text controller
              textController.clear();

              //close the dialog
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Notes"),
      ),
      drawer: const appDrawer(),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          openNoteBox();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          ///when we will have data , get all the data
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            ///display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //get each note
                DocumentSnapshot document = notesList[index];
                String documentID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteTxt = data['note'];

                // display as a list tile
                return ListTile(
                  title: Text(noteTxt),
                  trailing: IconButton(
                    onPressed: () {
                      openNoteBox(docID: documentID);
                    },
                    icon: Icon(Icons.update),
                  ),
                  onLongPress: () {
                    firestoreService.deleteNote(documentID);
                  },
                );
              },
            );
          } else {
            return const Text("No Notes");
          }
        },
      ),
    );
  }
}
