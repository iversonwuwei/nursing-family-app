import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class SparklineChart extends StatelessWidget {
  const SparklineChart({super.key, required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
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

    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (var index = 1; index <= 2; index++) {
      final y = size.height * (index / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
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
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.24),
          AppColors.info.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.24)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);

    final lastX = stepX * (points.length - 1);
    final lastNormalized = (points.last - minValue) / spread;
    final lastY = size.height - (lastNormalized * (size.height - 8)) - 4;
    final dotGlow = Paint()..color = AppColors.primary.withValues(alpha: 0.18);
    final dotPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(lastX, lastY), 7, dotGlow);
    canvas.drawCircle(Offset(lastX, lastY), 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
