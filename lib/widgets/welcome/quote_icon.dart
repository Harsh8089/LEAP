import 'package:flutter/material.dart';

class QuotesIcon extends StatelessWidget {
  final double size;
  final Color color;

  const QuotesIcon({Key? key, this.size = 24.0, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _QuotesPainter(color: color),
    );
  }
}

class _QuotesPainter extends CustomPainter {
  final Color color;

  _QuotesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final leftQuotePath = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.45, 0)
      ..lineTo(size.width * 0.35, size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height)
      ..lineTo(0, size.height)
      ..close();

    final rightQuotePath = Path()
      ..moveTo(size.width * 0.55, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.3)
      ..lineTo(size.width * 0.95, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.9, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.55, size.height)
      ..close();

    canvas.drawPath(leftQuotePath, paint);
    canvas.drawPath(rightQuotePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}