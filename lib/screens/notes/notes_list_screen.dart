import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/auth/logout.dart';
import 'package:notes_app/screens/notes/note_editor_screen.dart';
import 'package:notes_app/core/services/firestore_service.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});
  static const path = '/notelistscreen';

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final FirestoreStore _firestoreStore = FirestoreStore();

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
      body: StreamBuilder<List<Note>>(
        stream: _firestoreStore.getNotesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Note> notes = snapshot.data!;

          return ListView.builder(
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
                    await _firestoreStore.updateNote(updatedNote);
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _firestoreStore.deleteNote(notes[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _firestoreStore.addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
