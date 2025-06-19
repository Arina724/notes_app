import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/note.dart';
import 'package:notes_app/screens/notes/drawing_screen.dart';

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

  Future<void> _saveNote() async {
    setState(() {
      widget.note.title = _titleController.text;
      widget.note.content = _contentController.text;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.note.id)
          .set(widget.note.toMap());

      if (mounted) {
        Navigator.pop(context, widget.note);
      }
    } catch (e) {
      print("Ошибка при сохранении заметки: $e");
    }
  }

  void _clearDrawings() {
    setState(() {
      widget.note.drawings.clear();
    });
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Сохранить'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final drawingData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawingScreen(initialDrawing: []),
                    ),
                  );

                  if (drawingData != null) {
                    setState(() {
                      widget.note.drawings.addAll(drawingData);
                    });
                  }
                },
                child: const Text("Добавить рисунок"),
              ),
              ElevatedButton(
                onPressed: _clearDrawings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Очистить"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: widget.note.drawings.isEmpty
                ? const Center(child: Text("Нет рисунков"))
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: CustomPaint(
                          painter: _DrawingPainter(widget.note.drawings),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// DrawingPainter 
class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 1, 0, 2)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}
