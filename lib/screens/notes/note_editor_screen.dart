import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
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
  late String id;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    id = widget.note.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _clearDrawings() {
    setState(() {
      widget.note.drawings.clear();
    });
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
          Scrollbar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ElevatedButton(
                  onPressed: (){
                    context.read<NotesCubit>().updateNote(Note(id: id, title: _titleController.text, content: _contentController.text, drawings: widget.note.drawings));
                    context.pop();
                    },
                  child: const Text('Сохранить'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final drawingData = await context.push<List<List<Offset>>>(
                       '/drawing',
                        extra: widget.note.drawings
                        ///<List<List<Offset>>>[],
                      );
                    // final List<List<Offset>>? drawingData = await Navigator.push(
                    //   context,
                    //   context.push('/drawing')(
                    //     builder: (context) => DrawingScreen(initialDrawing: []),
                    //   ),
                    // );
                              
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
