import 'dart:ui';

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

  Future<List<Note>> getNotesOnce() async {
  final snapshot = await _firestore
      .collection('users')
      .doc(currentUser!.uid)
      .collection('notes')
      .get();

  return snapshot.docs.map((doc) { 
    final drawingsData = doc['drawings'] as List<dynamic>? ?? [];
    
    // Преобразуем в List<ColoredStroke>
    final drawings = drawingsData.map((drawing) {
      return ColoredStroke(
        points: (drawing['points'] as List<dynamic>).map((point) {
          return Offset(
            (point['dx'] as num).toDouble(),
            (point['dy'] as num).toDouble(),
          );
        }).toList(),
        color: Color(drawing['color'] as int),
        strokeWidth: (drawing['strokeWidth'] as num).toDouble(),
      );
    }).toList();
    
    return Note(
    id: doc.id,
    title: doc['title'] ?? '',
    content: doc['content'] ?? '',
    drawings: drawings, 
  );}).toList();
}


  // Добавление новой заметки
  Future<void> addNote() async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').add({
      'title': '',
      'content': '',
      'drawings': [], 
    });
  }

  // Обновление заметки
  Future<void> updateNote(Note note) async {
    try {
      // Преобразуем объект Note в Map и сохраняем в Firestore
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('notes')
          .doc(note.id)
          .update(note.toMap()); 
    } catch (e) {
      print("Ошибка при обновлении заметки: $e");
    }
  }

  // Удаление заметки
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').doc(noteId).delete();
  }
}
