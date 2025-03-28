import 'package:flutter/material.dart';
import '../models/note.dart';
import 'drawing_screen.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;

  const NoteEditorScreen({super.key, required this.note});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    // Инициализация контроллера для заголовка
    _titleController = TextEditingController(text: widget.note.title);
  }

  @override
  void dispose() {
    _titleController.dispose(); // Не забываем освободить ресурсы
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать заметку')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              onChanged: (text) {
                widget.note.title = text;  // Обновляем заголовок в модели
              },
              decoration: const InputDecoration(hintText: "Введите заголовок..."),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: TextEditingController(text: widget.note.content),
              onChanged: (text) => widget.note.content = text,
              decoration: const InputDecoration(hintText: "Введите текст..."),
              maxLines: null,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrawingScreen(note: widget.note),
                ),
              ).then((_) => setState(() {})); // Обновляем экран после возврата
            },
            child: const Text("Добавить рисунок"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.note.drawings!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: CustomPaint(
                      painter: DrawingPainter(widget.note.drawings![index]),
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
