import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ScannerOverlay extends StatefulWidget {
  final bool isDetected;

  const ScannerOverlay({super.key, this.isDetected = false});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _scanAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDetected ? AppColors.neonEmerald : AppColors.electricBlue;
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _ReticlePainter(
            color: color,
            scanProgress: _scanAnimation.value,
            cornerGlow: sin(_scanAnimation.value * pi) * 0.5 + 0.5,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ReticlePainter extends CustomPainter {
  final Color color;
  final double scanProgress;
  final double cornerGlow;

  _ReticlePainter({
    required this.color,
    required this.scanProgress,
    required this.cornerGlow,
  });

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

    _drawCornerBrackets(canvas, left, top, rectSize);
    _drawScanLine(canvas, left, top, rectSize);
  }

  void _drawCornerBrackets(Canvas canvas, double left, double top, double size) {
    const cornerLength = 28.0;
    const gap = 4.0;

    final cornerPaint = Paint()
      ..color = color.withValues(alpha: 0.6 + cornerGlow * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: cornerGlow * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final corners = [
      Offset(left - gap, top - gap),
      Offset(left + size + gap, top - gap),
      Offset(left - gap, top + size + gap),
      Offset(left + size + gap, top + size + gap),
    ];

    for (final corner in corners) {
      final isTop = corner.dy < top + size / 2;
      final isLeft = corner.dx < left + size / 2;

      for (final paint in [glowPaint, cornerPaint]) {
        canvas.drawLine(
          corner,
          corner + Offset(isLeft ? cornerLength : -cornerLength, 0),
          paint,
        );
        canvas.drawLine(
          corner,
          corner + Offset(0, isTop ? cornerLength : -cornerLength),
          paint,
        );
      }
    }
  }

  void _drawScanLine(Canvas canvas, double left, double top, double size) {
    final scanY = top + size * scanProgress;
    final scanLeft = left + 8;
    final scanRight = left + size - 8;
    final scanWidth = scanRight - scanLeft;

    final gradient = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.7),
          color.withValues(alpha: 1),
          color.withValues(alpha: 0.7),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(scanLeft, 0, scanWidth, 0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(scanLeft, scanY),
      Offset(scanRight, scanY),
      gradient,
    );

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(left + size / 2, scanY),
        width: size * 0.6,
        height: 20,
      ));

    canvas.drawRect(
      Rect.fromLTWH(left + size * 0.15, scanY - 10, size * 0.7, 20),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(_ReticlePainter old) =>
      old.color != color ||
      old.scanProgress != scanProgress ||
      old.cornerGlow != cornerGlow;
}
