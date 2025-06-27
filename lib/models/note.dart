import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';

class ColoredStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  ColoredStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points.map((p) => {'dx': p.dx, 'dy': p.dy}).toList(),
      'color': color.value,
      'strokeWidth': strokeWidth,
    };
  }

  factory ColoredStroke.fromMap(Map<String, dynamic> map) {
    return ColoredStroke(
      points: (map['points'] as List<dynamic>)
          .map((point) => Offset(point['dx'], point['dy']))
          .toList(),
      color: Color(map['color']),
      strokeWidth: (map['strokeWidth'] as num).toDouble(),
    );
  }
}

class Note {
  String id;
  String title;
  String content;
  List<ColoredStroke> drawings;

  Note({
    required this.id,
    required this.title,
    required this.content,
    List<ColoredStroke>? drawings,
  }) : drawings = drawings ?? [];

  void addDrawing(List<ColoredStroke> newDrawings) {
    drawings.addAll(newDrawings);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'drawings': drawings.map((d) => d.toMap()).toList(),
    };
  }

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    log("From Map");
    return Note(
      id: id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      drawings: (data['drawings'] as List<dynamic>?)
              ?.map((item) => ColoredStroke.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
    );
  }
}
