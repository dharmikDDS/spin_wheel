import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spin_wheel/colors.dart';
import 'package:spin_wheel/prize_item_model.dart';

class WheelPainter extends CustomPainter {
  final List<PrizeItem> prizes;

  WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final Paint paint = Paint()..style = PaintingStyle.fill;
    final segmentAngle = 2 * pi / prizes.length;

    // Draw each segment
    for (int i = 0; i < prizes.length; i++) {
      final startAngle = i * segmentAngle;

      // Set segment color
      paint.color = prizes[i].color;

      // Draw segment
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Draw segment divider
      final borderPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(
          centerX + radius * cos(startAngle),
          centerY + radius * sin(startAngle),
        ),
        borderPaint,
      );

      // Draw text from center to outer edge
      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i].label,
          style: prizes[i].style ??
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        textWidthBasis: TextWidthBasis.parent,
      );

      textPainter.layout();

      final double textAngle = startAngle + segmentAngle / 2;

      // Rotate text so it's vertical when at the bottom of the wheel
      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(textAngle);

      // Position text to start near center and run toward edge
      // First measure text width to calculate proper positioning
      final double textStartRadius = radius * 0.25;

      // Paint the text
      canvas.translate(textStartRadius, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      // Draw small circles at segment edges
      final dotPaint = Paint()..color = primaryColor;
      canvas.drawCircle(
        Offset(
          centerX + radius * cos(startAngle),
          centerY + radius * sin(startAngle),
        ),
        8,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
