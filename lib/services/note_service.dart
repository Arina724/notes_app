import '../models/note.dart';

class NoteService {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  // для добавления заметки
  void addNote(String title) {
    _notes.add(Note(title: title, content: ""));
  }
}
 