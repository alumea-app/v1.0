import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  TimelinePainter({required this.isFirst, required this.isLast, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2;

    final double centerX = size.width / 2;
    final double startY = isFirst ? size.height / 2 : 0;
    final double endY = isLast ? size.height / 2 : size.height;

    canvas.drawLine(Offset(centerX, startY), Offset(centerX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
