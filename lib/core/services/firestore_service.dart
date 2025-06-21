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

  return snapshot.docs.map((doc) => Note(
    id: doc.id,
    title: doc['title'] ?? '',
    content: doc['content'] ?? '',
    drawings: [], // или правильно обработай drawings
  )).toList();
}


  // Добавление новой заметки
  Future<void> addNote() async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').add({
      'title': '',
      'content': '',
      'drawings': [],  // Пустой список для рисунков
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
          .update(note.toMap());  // Используем toMap для правильной сериализации данных
    } catch (e) {
      print("Ошибка при обновлении заметки: $e");
    }
  }

  // Удаление заметки
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('users').doc(currentUser!.uid).collection('notes').doc(noteId).delete();
  }
}
