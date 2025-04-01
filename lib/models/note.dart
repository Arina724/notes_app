import 'dart:ui';

class Note {
  String id;
  String title;
  String content;
  List<List<Offset>> drawings;

  Note({
    required this.id,
    required this.title,
    required this.content,
    List<List<Offset>>? drawings,
  }) : drawings = drawings ?? [];

  // Метод для добавления нового рисунка
  void addDrawing(List<List<Offset>> newDrawings) {
    drawings.addAll(newDrawings);
  }

  // Преобразование в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'drawings': drawings
          .map((stroke) => stroke.map((point) => {'dx': point.dx, 'dy': point.dy}).toList())
          .toList(),
    };
  }

  // Создание объекта Note из Firestore
  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      drawings: (data['drawings'] as List<dynamic>? ?? [])
          .map((stroke) => (stroke as List<dynamic>)
              .map((point) => Offset((point as Map<String, dynamic>)['dx'], point['dy']))
              .toList())
          .toList(),
    );
  }
}
