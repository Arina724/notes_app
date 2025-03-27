import 'dart:ui';
class Note {
  String title;
  String content;
  List<Offset>? drawing;
  Note({required this.title,
   required this.content,
   this.drawing = const[],
   });
}

