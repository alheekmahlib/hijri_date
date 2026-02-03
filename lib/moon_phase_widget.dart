import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'moon_phases.dart';

/// ويدجت لعرض طور القمر بصريًا باستخدام SVG وقناع هندسي.
class MoonPhaseWidget extends StatelessWidget {
  /// معلومات طور القمر (يفضّل أخذها من MoonPhaseCalculator أو HijriDate)
  final MoonPhaseInfo moonInfo;

  /// حجم الودجت (العرض والارتفاع متساويان)
  final double size;

  /// لون طبقة الظل فوق القمر
  final Color overlayColor;

  /// شفافية طبقة الظل (افتراضيًا 0)
  final double overlayOpacity;

  /// مسار SVG للقمر (قابل للتمرير)
  final String moonAssetPath;

  /// مسار SVG للخلفية (اختياري)
  final String? backgroundAssetPath;

  /// اسم الحزمة للأصول (افتراضيًا hijri_date)
  final String? assetPackage;

  /// طريقة احتواء الـ SVG
  final BoxFit fit;

  /// استخدام إضاءة مبنية على الطور بدل القيمة الفعلية
  final bool usePhaseBasedIllumination;

  /// نسبة امتلاء دائرة القمر داخل الودجت (0 - 1)
  final double moonScale;

  const MoonPhaseWidget({
    super.key,
    required this.moonInfo,
    this.size = 160,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0,
    this.moonAssetPath = 'assets/moon.svg',
    this.backgroundAssetPath,
    this.assetPackage = 'hijri_date',
    this.fit = BoxFit.contain,
    this.usePhaseBasedIllumination = false,
    this.moonScale = 0.9,
  })  : assert(overlayOpacity >= 0 && overlayOpacity <= 1),
        assert(moonScale > 0 && moonScale <= 1);

  @override
  Widget build(BuildContext context) {
    final effectiveIllumination = usePhaseBasedIllumination
        ? _phaseToIllumination(moonInfo.phase)
        : moonInfo.illumination;

    return SizedBox(
      width: size + 40,
      height: size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (backgroundAssetPath != null)
            SvgPicture.asset(
              backgroundAssetPath!,
              package: assetPackage,
              width: size + 40,
              height: size + 40,
              fit: BoxFit.cover,
            ),
          SvgPicture.asset(
            moonAssetPath,
            package: assetPackage,
            width: size - 30,
            height: size - 30,
            fit: fit,
          ),
          if (overlayOpacity > 0)
            CustomPaint(
              size: Size(size - 30, size - 30),
              painter: _MoonPhaseOverlayPainter(
                phase: moonInfo.phase,
                illumination: effectiveIllumination,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                moonScale: moonScale,
              ),
            ),
        ],
      ),
    );
  }

  double _phaseToIllumination(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return 0;
      case MoonPhase.waxingCrescent:
        return 0.25;
      case MoonPhase.firstQuarter:
        return 0.5;
      case MoonPhase.waxingGibbous:
        return 0.75;
      case MoonPhase.fullMoon:
        return 1;
      case MoonPhase.waningGibbous:
        return 0.75;
      case MoonPhase.lastQuarter:
        return 0.5;
      case MoonPhase.waningCrescent:
        return 0.25;
    }
  }
}

class _MoonPhaseOverlayPainter extends CustomPainter {
  final MoonPhase phase;
  final double illumination;
  final Color overlayColor;
  final double overlayOpacity;
  final double moonScale;

  const _MoonPhaseOverlayPainter({
    required this.phase,
    required this.illumination,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.moonScale,
  });

  bool get _isWaxing {
    return phase == MoonPhase.waxingCrescent ||
        phase == MoonPhase.firstQuarter ||
        phase == MoonPhase.waxingGibbous;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final k = illumination.clamp(0.0, 1.0);
    if (overlayOpacity <= 0) return;

    if (k <= 0) {
      _drawFullShadow(canvas, size);
      return;
    }

    if (k >= 1) {
      return;
    }

    _drawCircularShadow(canvas, size, k);
  }

  void _drawFullShadow(Canvas canvas, Size size) {
    final r = size.width / 2 * moonScale;
    final center = Offset(size.width / 2, size.height / 2);
    final shadowPaint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r, shadowPaint);
  }

  void _drawCircularShadow(Canvas canvas, Size size, double k) {
    final r = size.width / 2 * moonScale;
    final center = Offset(size.width / 2, size.height / 2);
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r));

    canvas.clipPath(clipPath);

    final shadowPaint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;
    final d = (2 * r * k).clamp(0.0, 2 * r);
    final dx = _isWaxing ? -d : d;
    canvas.drawCircle(Offset(center.dx + dx, center.dy), r, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _MoonPhaseOverlayPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.illumination != illumination ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.overlayOpacity != overlayOpacity;
  }
}
