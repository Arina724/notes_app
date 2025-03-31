import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'note_editor_screen.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/auth/logout.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});
  static const path = '/notelistscreen';

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [
    Note(title: 'Заметка 1', content: 'Содержимое заметки 1', drawings: []),
  ];

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index); // Удаляем заметку из списка
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => context.go(LogoutScreen.path),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            onTap: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditorScreen(note: notes[index]),
                ),
              );

              if (updatedNote != null) {
                setState(() {
                  notes[index] = updatedNote; // Обновляем заметку
                });
              }
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteNote(index), // Вызываем удаление
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            notes.add(Note(title: 'Новая заметка', content: '', drawings: []));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
