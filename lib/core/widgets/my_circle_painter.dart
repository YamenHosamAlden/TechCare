import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyCirclePainter extends CustomPainter {
  final double radius;
  final Color color;
  MyCirclePainter(this.radius, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color; // Replace with your desired color
    final path = Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: radius,
              height: radius),
          0,
          2 * math.pi);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyCirclePainter oldDelegate) =>
      radius != oldDelegate.radius;
}
