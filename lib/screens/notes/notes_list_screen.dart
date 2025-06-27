import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/auth/logout.dart';
import 'package:notes_app/screens/notes/note_editor_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});
  static const String path = '/notes';

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          IconButton(onPressed: () => context.read<NotesCubit>().loadNotes(), icon: const Icon(Icons.replay_outlined)),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => context.go(LogoutScreen.path),
          ),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(builder: (context, state){
        
        if(state is NotesLoading ){
          return Center( child: CircularProgressIndicator());
        } else if(state is NotesError){
          return Center( child: Text(state.props.toString()));
        } else if (state is NotesLoaded){
          List<Note> notes = state.notes;
          if (notes.isEmpty){
            return Center(child: Text('Нет заметок'));
          }else {
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index].title == '' ? 'новая заметка': notes[index].title),
                onTap: () async {
                  final updatedNote = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(note: notes[index]),
                    ),
                  );

                  if (updatedNote != null) {
                    await context.read<NotesCubit>().updateNote(updatedNote);
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => context.read<NotesCubit>().deleteNote(notes[index].id),
                ),
              );
            },
          );}
        } else {
            return Center( child: Text('Обновите список'));
        }},),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {  
          final id =UniqueKey().toString();
          final newNote = Note(
    id: id, 
    title: '',
    content: '',
    drawings: [],
  );
  context.read<NotesCubit>().addNote(newNote);
await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(note: newNote),
                    ),
                  );   
        },
        child: const Icon(Icons.add),
      ));}}
  