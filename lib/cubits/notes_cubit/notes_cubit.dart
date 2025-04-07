import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/core/services/note_service.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteService notesService;

  NotesCubit(this.notesService) : super(NotesInitial());

  Future<void> loadNotes() async {
    try {
      emit(NotesLoading());
      final notes = await notesService.getNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(Note note) async {
    await notesService.addNote(note);
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
