import 'dart:math';

import 'package:flutter/material.dart';

import '../common/app_colors.dart';
class ChartPainter extends CustomPainter {
  final double percentage;
  final double indicatorSize;

  ChartPainter(this.percentage, this.indicatorSize);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - indicatorSize / 2; // Adjust the radius to accommodate the indicator size

    final backgroundPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final progressPaint = Paint()
      ..color = Colours.fontColor2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}