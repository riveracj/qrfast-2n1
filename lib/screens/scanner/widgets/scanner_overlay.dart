import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ScannerOverlay extends StatelessWidget {
  final bool isDetected;

  const ScannerOverlay({super.key, this.isDetected = false});

  @override
  Widget build(BuildContext context) {
    final color = isDetected ? AppColors.neonEmerald : AppColors.white;
    return CustomPaint(
      painter: _ReticlePainter(color: color),
      child: const SizedBox.expand(),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  final Color color;

  _ReticlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rectSize = size.shortestSide * 0.6;
    final left = (size.width - rectSize) / 2;
    final top = (size.height - rectSize) / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, rectSize, rectSize),
      const Radius.circular(16),
    );

    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(rect),
      ),
      bgPaint,
    );

    final cornerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const cornerLength = 28.0;
    const gap = 4.0;

    final corners = [
      Offset(left - gap, top - gap),
      Offset(left + rectSize + gap, top - gap),
      Offset(left - gap, top + rectSize + gap),
      Offset(left + rectSize + gap, top + rectSize + gap),
    ];

    for (final corner in corners) {
      final isTop = corner.dy < top + rectSize / 2;
      final isLeft = corner.dx < left + rectSize / 2;

      canvas.drawLine(
        corner,
        corner + Offset(isLeft ? cornerLength : -cornerLength, 0),
        cornerPaint,
      );
      canvas.drawLine(
        corner,
        corner + Offset(0, isTop ? cornerLength : -cornerLength),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ReticlePainter old) => old.color != color;
}
