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
  Future<void> _saveNote() async {
    setState(() {
      widget.note.title = _titleController.text;
      widget.note.content = _contentController.text;
    });

    try {
      // Сохраняем данные заметки в Firestore, включая рисунки
      await FirebaseFirestore.instance.collection('notes').doc(widget.note.id).set({
        'title': widget.note.title,
        'content': widget.note.content,
        'drawings': widget.note.drawings, // Сохраняем список координат рисования
      });

      // После успешного сохранения возвращаемся на предыдущий экран
      if (mounted) {
        Navigator.pop(context, widget.note);
      }
    } catch (e) {
      // Обработка ошибок, если сохранение не удалось
      print("Ошибка при сохранении заметки: $e");
    }
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
            onPressed: _saveNote, // Теперь вызываем _saveNote с await
            child: const Text('Сохранить'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Открытие экрана для рисования и передача текущих рисунков
              final drawingData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrawingScreen(initialDrawing: widget.note.drawings),  // Передаем текущие рисунки
                ),
              );

              if (drawingData != null) {
                setState(() {
                  widget.note.drawings = drawingData; // Обновляем данные рисования в заметке
                });
              }
            },
            
            child: const Text("Добавить рисунок"),
          ),
          Expanded(
            child: widget.note.drawings.isEmpty
                ? Center(child: Text("Нет рисунков"))
                : ListView.builder(
                    itemCount: widget.note.drawings.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: CustomPaint(
                            painter: DrawingPainter([widget.note.drawings[index]]), // Рисуем с переданными точками
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
