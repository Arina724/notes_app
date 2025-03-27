import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_editor_screen.dart';
import '../models/note.dart'; 

class DrawingScreen extends StatefulWidget {
  final Note note;

  const DrawingScreen({super.key, required this.note});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState ();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  void _saveNote() {
    setState(() {
      widget.note.title = _titleController.text;
      widget.note.content = _contentController.text;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактор заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brush), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditorScreen (note: widget.note), 
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Содержание'),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
