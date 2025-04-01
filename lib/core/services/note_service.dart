import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note.dart';
import 'dart:ui';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  Stream<List<Note>> get notes {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Note(
                id: doc.id,
                title: doc['title'],
                content: doc['content'],
                drawings: (doc['drawings'] as List<dynamic>?)
                        ?.map((stroke) => (stroke as List<dynamic>)
                            .map((point) => Offset(
                                  (point as Map<String, dynamic>)['dx'],
                                  point['dy'],
                                ))
                            .toList())
                        .toList() ??
                    [],
              );
            }).toList());
  }

  Future<void> updateDrawings(String noteId, List<List<Offset>> drawings) async {
    List<List<Map<String, double>>> serializedDrawings = drawings
        .map((stroke) => stroke
            .map((point) => {'dx': point.dx, 'dy': point.dy})
            .toList())
        .toList();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({'drawings': serializedDrawings});
  }
}
