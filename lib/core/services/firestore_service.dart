import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note.dart';

class FirestoreStore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Получение потока заметок пользователя
  Stream<List<Note>> getNotesStream() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('notes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // Добавление новой заметки
  Future<void> addNote() async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').add({
      'title': 'Новая заметка',
      'content': '',
      'drawings': [],
    });
  }

  // Обновление заметки
  Future<void> updateNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  // Удаление заметки
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').doc(noteId).delete();
  }
}
