import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/services/firestore_service.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/core/services/note_service.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteService notesService;
  final FirestoreStore firestoreStore = FirestoreStore();

  NotesCubit(this.notesService) : super(NotesInitial());

  Future<void> loadNotes() async {
    try {
      emit(NotesLoading());
      List<Note> notes = await firestoreStore.getNotesOnce();
      emit(NotesLoaded(notes));
      log('Notes = ' + notes[0].toString());
    } catch (e) {
      emit(NotesError(e.toString()));
      log('Ошибка ${e.toString()}');
    }
  }

  Future<void> addNote() async {
    await notesService.addNote();
    loadNotes(); // после добавления — обновляем список
  }

  Future<void> updateNote(Note note) async {
    await notesService.updateNote(note);
    loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await notesService.deleteNote(id);
    loadNotes();
  }
}
