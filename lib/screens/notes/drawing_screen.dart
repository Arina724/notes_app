import 'package:flutter/material.dart';
import '../../models/note.dart';

class DrawingScreen extends StatefulWidget {
  final Note note;

  const DrawingScreen({super.key, required this.note});
  static String path = '/logout';

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<List<Offset>> _drawingHistory = [];
  List<List<Offset>> _redoStack = [];
  List<Offset> _currentStroke = [];

  void _undo() {
    if (_drawingHistory.isNotEmpty) {
      setState(() {
        _redoStack.add(_drawingHistory.removeLast());
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _drawingHistory.add(_redoStack.removeLast());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Рисование"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_drawingHistory.isNotEmpty) {
                widget.note.addDrawing(_drawingHistory);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          _currentStroke = [details.localPosition];
        },
        onPanUpdate: (details) {
          setState(() {
            _currentStroke.add(details.localPosition);
          });
        },
        onPanEnd: (_) {
          if (_currentStroke.isNotEmpty) {
            setState(() {
              _drawingHistory.add(List.from(_currentStroke));
              _redoStack.clear();
              _currentStroke = [];
            });
          }
        },
        child: CustomPaint(
          painter: DrawingPainter(_drawingHistory),
          size: Size.infinite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _undo,
            child: Icon(Icons.undo),
            tooltip: "Отменить",
          ),
          FloatingActionButton(
            onPressed: _redo,
            child: Icon(Icons.redo),
            tooltip: "Вернуть",
          ),
        ],
      ),
    );
  }
}

// Класс, который рисует линии
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> drawingHistory;

  DrawingPainter(this.drawingHistory);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (var stroke in drawingHistory) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
