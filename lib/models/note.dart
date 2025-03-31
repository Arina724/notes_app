import 'dart:ui';

class Note {
  String title;
  String content;
  List<List<Offset>> drawings;

  Note({
    required this.title,
    required this.content,
    List<List<Offset>>? drawings,
  }) : drawings = drawings ?? [];

  void addDrawing(List<List<Offset>> newDrawings) {
    drawings.addAll(newDrawings);
  }
}
