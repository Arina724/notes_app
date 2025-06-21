import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/models/note.dart';
import 'dart:ui';

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
            return Note(
              id: doc.id,
              title: doc['title'] as String? ?? '',
              content: doc['content'] as String? ?? '',
              drawings: (doc['drawings'] as List?)
                      ?.map<List<Offset>>((stroke) {
                        if (stroke is! List) return [];
                        return stroke.map<Offset>((point) {
                          final map = point as Map<String, dynamic>? ?? {};
                          final dx = (map['dx'] as num?)?.toDouble() ?? 0.0;
                          final dy = (map['dy'] as num?)?.toDouble() ?? 0.0;
                          return Offset(dx, dy);
                        }).toList();
                      }).toList() ?? [],
            );
          }).toList());
}


  /// Добавление новой заметки
  Future<void> addNote() async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add({
      'title': '',
      'content': '',
      'drawings': []
          .map((stroke) => stroke
              .map((point) => {'dx': point.dx, 'dy': point.dy})
              .toList())
          .toList(),
    });
  }

  /// Обновление заметки (и текста, и рисунков)
  // Future<void> updateNote(Note note) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('notes')
  //       .doc(note.id)
  //       .update({
  //     'title': note.title,
  //     'content': note.content,
  //     'drawings': note.drawings
  //         .map((stroke) => stroke
  //             .map((point) => {'dx': point.dx, 'dy': point.dy})
  //             .toList())
  //         .toList(),
  //   });
  // }
  Future<void> updateNote(Note note) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('notes')
      .doc(note.id)
      .set(note.toMap()); // toMap() должен включать drawings
}

  /// Обновление только рисунков в заметке
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
