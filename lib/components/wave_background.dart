import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';

class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, size.height * 0.44)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.39,
        size.width * 0.48,
        size.height * 0.41,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.43,
        size.width,
        size.height * 0.33,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WaveBackgroundPainterShort extends CustomPainter {
  final double baseHeight;

  WaveBackgroundPainterShort({required this.baseHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, baseHeight)
      ..quadraticBezierTo(
        size.width * 0.25,
        baseHeight - 40,
        size.width * 0.48,
        baseHeight - 20,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        baseHeight + 10,
        size.width,
        baseHeight - 30,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
