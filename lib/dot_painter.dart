import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyFLPainter extends FlDotPainter {
  MyFLPainter({
    required this.color,
    double? radius,
    required this.ssid,
  }) : radius = radius ?? 4.0;

  Color color;
  double radius;

  final String ssid;

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    canvas.drawCircle(
      offsetInCanvas,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    TextSpan span = TextSpan(style: TextStyle(color: color), text: ssid);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout(maxWidth: 100);

    tp.paint(canvas, offsetInCanvas.translate(-tp.width / 2, -30));
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(max(radius * 2, 100), max(radius * 2, 100));
  }

  @override
  List<Object?> get props => [
        color,
        radius,
      ];
}
