import 'package:flutter/material.dart';
import '../services/note_service.dart';
import 'note_editor_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final NoteService _noteService = NoteService();

  void _addNewNote() {
    setState(() {
      _noteService.addNote("Новая заметка");
    });
  }

  void _openNote(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: _noteService.notes[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      body: ListView.builder(
        itemCount: _noteService.notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_noteService.notes[index].title),
            onTap: () => _openNote(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
