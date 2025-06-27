import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  /// Получаем все заметки пользователя
  Stream<List<Note>> get notes {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Note.fromMap(doc.id, doc.data());
            }).toList());
  }

Future<void> addNewNote(Note newNote)async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add({
      'title': newNote.title,
      'content': newNote.content,
      'drawings': newNote.drawings,
    });
  }

  /// Обновление заметки (всего объекта)
  Future<void> updateNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  /// Обновление только рисунков
  Future<void> updateDrawings(String noteId, List<ColoredStroke> drawings) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({
      'drawings': drawings.map((stroke) => stroke.toMap()).toList(),
    });
  }

  /// Удаление заметки
  Future<void> deleteNote(String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .delete();
  }

  getNotes() {}
}
