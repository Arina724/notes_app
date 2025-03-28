import 'package:flutter/material.dart';
import '../models/note.dart';

class DrawingScreen extends StatefulWidget {
  final Note note;

  const DrawingScreen({super.key, required this.note});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = []; // Список точек для рисования

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Рисование"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (points.isNotEmpty){
                widget.note.drawings!.add(points.whereType<Offset>().toList());
              }
              Navigator.pop(context);// Закрываем экран рисования 
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition); // Добавляем точку при движении пальца
          });
        },
        onPanEnd: (_) {
          setState(() {
            points.add(null); // Разрыв линии при отпускании пальца
          });
        },
        child: CustomPaint(
          painter: DrawingPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// Класс, который рисует линии
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Обязательно перерисовываем при обновлении
  }
}
