import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class DrawingScreen extends StatefulWidget {
  final List<ColoredStroke> initialDrawing;

  const DrawingScreen({super.key, required this.initialDrawing});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late List<ColoredStroke> _drawingHistory;
  List<ColoredStroke> _redoStack = [];

  List<Offset> _currentStroke = [];

  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;

  @override
  void initState() {
    super.initState();
    // Копируем список с начальным рисунком
    _drawingHistory = List.from(widget.initialDrawing);
  }

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

  void _setColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _setEraser() {
    setState(() {
      _selectedColor = Colors.white;
    });
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
              // Возвращаем весь список с цветными штрихами
              Navigator.pop(context, _drawingHistory);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Панель выбора цвета и толщины
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              children: [
                const Icon(Icons.color_lens),
                const SizedBox(width: 8),
                _buildColorCircle(Colors.black),
                _buildColorCircle(Colors.red),
                _buildColorCircle(Colors.green),
                _buildColorCircle(Colors.blue),
                _buildColorCircle(Colors.yellow),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _setEraser,
                  tooltip: "Ластик",
                ),
                const SizedBox(width: 8),
                const Text("Толщина"),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 20,
                    value: _strokeWidth,
                    onChanged: (value) {
                      setState(() {
                        _strokeWidth = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Зона рисования
          Expanded(
            child: GestureDetector(
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
                    _drawingHistory.add(
                      ColoredStroke(
                        points: List.from(_currentStroke),
                        color: _selectedColor,
                        strokeWidth: _strokeWidth,
                      ),
                    );
                    _currentStroke = [];
                    _redoStack.clear();
                  });
                }
              },
              child: CustomPaint(
                painter: DrawingPainter(_drawingHistory),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _undo,
            tooltip: "Отменить",
            child: const Icon(Icons.undo),
          ),
          FloatingActionButton(
            onPressed: _redo,
            tooltip: "Вернуть",
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () => _setColor(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 2,
              color: _selectedColor == color ? Colors.black : Colors.grey),
        ),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 12,
        ),
      ),
    );
  }
}



class DrawingPainter extends CustomPainter {
  final List<ColoredStroke>? strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    
    for (final stroke in strokes!) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
