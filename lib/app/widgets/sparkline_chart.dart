import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class SparklineChart extends StatelessWidget {
  const SparklineChart({super.key, required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: CustomPaint(painter: _SparklinePainter(points)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.points);

  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final minValue = points.reduce((a, b) => a < b ? a : b);
    final maxValue = points.reduce((a, b) => a > b ? a : b);
    final spread = (maxValue - minValue) == 0 ? 1 : (maxValue - minValue);
    final stepX = points.length == 1
        ? size.width
        : size.width / (points.length - 1);

    final path = Path();
    for (var index = 0; index < points.length; index++) {
      final dx = stepX * index;
      final normalized = (points[index] - minValue) / spread;
      final dy = size.height - (normalized * (size.height - 8)) - 4;
      if (index == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x334CAF50), Color(0x00FFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
