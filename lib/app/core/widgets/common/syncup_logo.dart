import 'package:flutter/material.dart';

/// The official SyncUp "Connected S" Brand Logo widget.
/// Supports both Dark Mode and Light Mode automatically or via [isDark] parameter.
/// Supports optional path-draw animation, node pop, and center pulse.
class SyncUpLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showGlow;
  final bool? isDark;
  final double drawProgress;
  final double nodeProgress;
  final double centerDotPulse;

  const SyncUpLogo({
    super.key,
    this.size = 80,
    this.borderRadius = 22,
    this.showGlow = true,
    this.isDark,
    this.drawProgress = 1.0,
    this.nodeProgress = 1.0,
    this.centerDotPulse = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark ?? (Theme.of(context).brightness == Brightness.dark);

    final bgColor = effectiveIsDark ? const Color(0xFF160D12) : const Color(0xFFFFFFFF);
    final borderColor = effectiveIsDark
        ? const Color(0xFFFB7185).withAlpha(60)
        : const Color(0xFFFECDD3);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.3),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: effectiveIsDark
                      ? const Color(0xFF8B0021).withAlpha(120)
                      : const Color(0xFF8B0021).withAlpha(25),
                  offset: const Offset(0, 8),
                  blurRadius: effectiveIsDark ? 30 : 20,
                  spreadRadius: effectiveIsDark ? 2 : 0,
                ),
                if (effectiveIsDark)
                  BoxShadow(
                    color: const Color(0xFFBE123C).withAlpha(80),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.75, size * 0.75),
          painter: _ConnectedSPainter(
            isDark: effectiveIsDark,
            drawProgress: drawProgress,
            nodeProgress: nodeProgress,
            centerDotPulse: centerDotPulse,
          ),
        ),
      ),
    );
  }
}

class _ConnectedSPainter extends CustomPainter {
  final bool isDark;
  final double drawProgress;
  final double nodeProgress;
  final double centerDotPulse;

  _ConnectedSPainter({
    required this.isDark,
    this.drawProgress = 1.0,
    this.nodeProgress = 1.0,
    this.centerDotPulse = 1.0,
  });

  Path _extractPath(Path src, double progress) {
    if (progress >= 1.0) return src;
    if (progress <= 0.0) return Path();
    final dst = Path();
    for (final metric in src.computeMetrics()) {
      dst.addPath(
        metric.extractPath(0.0, metric.length * progress),
        Offset.zero,
      );
    }
    return dst;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final grad1Colors = isDark
        ? [const Color(0xFFFB7185), const Color(0xFFE11D48), const Color(0xFF8B0021)]
        : [const Color(0xFFE11D48), const Color(0xFF9F1239), const Color(0xFF8B0021)];

    final grad2Colors = isDark
        ? [const Color(0xFFFDA4AF), const Color(0xFFBE123C), const Color(0xFF4C0519)]
        : [const Color(0xFFF43F5E), const Color(0xFFBE123C), const Color(0xFF73001B)];

    final grad1 = LinearGradient(
      colors: grad1Colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final grad2 = LinearGradient(
      colors: grad2Colors,
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final paint1 = Paint()
      ..shader = grad1
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paint2 = Paint()
      ..shader = grad2
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Top loop: from center (0.48, 0.50) outwards to top node (0.72, 0.34)
    final path1 = Path()
      ..moveTo(w * 0.48, h * 0.50)
      ..cubicTo(w * 0.40, h * 0.45, w * 0.32, h * 0.40, w * 0.32, h * 0.30)
      ..cubicTo(w * 0.32, h * 0.20, w * 0.40, h * 0.14, w * 0.52, h * 0.14)
      ..cubicTo(w * 0.64, h * 0.14, w * 0.72, h * 0.21, w * 0.72, h * 0.32)
      ..lineTo(w * 0.72, h * 0.34);

    final drawnPath1 = _extractPath(path1, drawProgress);
    canvas.drawPath(drawnPath1, paint1);

    // Bottom loop: from center (0.52, 0.50) outwards to bottom node (0.28, 0.66)
    final path2 = Path()
      ..moveTo(w * 0.52, h * 0.50)
      ..cubicTo(w * 0.60, h * 0.55, w * 0.68, h * 0.60, w * 0.68, h * 0.70)
      ..cubicTo(w * 0.68, h * 0.80, w * 0.60, h * 0.86, w * 0.48, h * 0.86)
      ..cubicTo(w * 0.36, h * 0.86, w * 0.28, h * 0.79, w * 0.28, h * 0.68)
      ..lineTo(w * 0.28, h * 0.66);

    final drawnPath2 = _extractPath(path2, drawProgress);
    canvas.drawPath(drawnPath2, paint2);

    final innerDotPaint = Paint()..color = Colors.white;

    // Top node (pops in when nodeProgress > 0)
    if (nodeProgress > 0.0) {
      final nodeScale = nodeProgress.clamp(0.0, 1.4);
      final topNodePaint = Paint()
        ..color = isDark ? const Color(0xFFFB7185) : const Color(0xFFE11D48);
      canvas.drawCircle(Offset(w * 0.72, h * 0.34), (w * 0.08) * nodeScale, topNodePaint);
      canvas.drawCircle(Offset(w * 0.72, h * 0.34), (w * 0.038) * nodeScale, innerDotPaint);
    }

    // Bottom node (pops in when nodeProgress > 0)
    if (nodeProgress > 0.0) {
      final nodeScale = nodeProgress.clamp(0.0, 1.4);
      final botNodePaint = Paint()
        ..color = isDark ? const Color(0xFFFDA4AF) : const Color(0xFF8B0021);
      canvas.drawCircle(Offset(w * 0.28, h * 0.66), (w * 0.08) * nodeScale, botNodePaint);
      canvas.drawCircle(Offset(w * 0.28, h * 0.66), (w * 0.038) * nodeScale, innerDotPaint);
    }

    // Center dot with glow flash
    if (centerDotPulse > 0.0) {
      final centerScale = centerDotPulse.clamp(0.0, 2.0);
      final centerPaint = Paint()..color = isDark ? Colors.white : const Color(0xFF160D12);

      if (isDark && centerDotPulse > 1.0) {
        final glowPaint = Paint()
          ..color = const Color(0xFFFB7185).withAlpha(
            ((centerDotPulse - 1.0) * 160).clamp(0, 255).toInt(),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(w * 0.50, h * 0.50), (w * 0.14) * centerScale, glowPaint);
      }

      canvas.drawCircle(Offset(w * 0.50, h * 0.50), (w * 0.055) * centerScale, centerPaint);
      if (!isDark) {
        canvas.drawCircle(Offset(w * 0.50, h * 0.50), (w * 0.022) * centerScale, innerDotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectedSPainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.drawProgress != drawProgress ||
        oldDelegate.nodeProgress != nodeProgress ||
        oldDelegate.centerDotPulse != centerDotPulse;
  }
}
