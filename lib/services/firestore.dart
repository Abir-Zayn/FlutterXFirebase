import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  //get collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //Create >> add a new note
  Future<void> addNote(String note){
    return notes.add({
      'note' : note,
      'timestamp': Timestamp.now(),
    });
  }


  //Read >> get all notes

  Stream <QuerySnapshot> getNotes(){
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  //Update >> update a note
  /// Update a note in the database with the given document ID and new note content.
  ///
  /// Parameters:
  ///   docID: The document ID of the note to update.
  ///   newNote: The new content of the note.
  ///
  /// Returns a Future that completes once the note is updated.
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update(
        {'note': newNote, 'timestamp': Timestamp.now()}
    );
  }


  //Delete >> delete a note

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

}