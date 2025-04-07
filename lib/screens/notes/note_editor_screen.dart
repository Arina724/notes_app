import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/note.dart';
import 'drawing_screen.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;

  const NoteEditorScreen({super.key, required this.note});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Сохранение заметки в Firestore
  void _saveNote() {
    setState(() {
      widget.note.title = _titleController.text;
      widget.note.content = _contentController.text;
    });

    // Сохраняем данные заметки в Firestore, включая рисунки
    FirebaseFirestore.instance.collection('notes').doc(widget.note.id).set({
      'title': widget.note.title,
      'content': widget.note.content,
      'drawings': widget.note.drawings, // Сохраняем список координат рисования
    });

    Navigator.pop(context, widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать заметку')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              onChanged: (text) {
                widget.note.title = text;
              },
              decoration: const InputDecoration(hintText: "Введите заголовок..."),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              onChanged: (text) => widget.note.content = text,
              decoration: const InputDecoration(hintText: "Введите текст..."),
              maxLines: null,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveNote,
            child: const Text('Сохранить'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Открытие экрана для рисования
              final drawingData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrawingScreen(note: widget.note),
                ),
              );

              if (drawingData != null) {
                // Добавляем список точек рисования в заметку
                setState(() {
                  widget.note.drawings = drawingData; // Передаем список точек для рисования
                });
              }
            },
            child: const Text("Добавить рисунок"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.note.drawings.length,
              itemBuilder: (context, index) {
                List<Offset> drawingPoints = widget.note.drawings[index]; // Список точек
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: CustomPaint(
                      painter: DrawingPainter([widget.note.drawings[index]]), // Передаем список точек
                      size: Size.infinite,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
