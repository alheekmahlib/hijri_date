import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'moon_phases.dart';

/// ويدجت لعرض طور القمر بصريًا باستخدام صورة وقناع هندسي.
class MoonPhaseWidget extends StatelessWidget {
  /// معلومات طور القمر (يفضّل أخذها من MoonPhaseCalculator أو HijriDate)
  final MoonPhaseInfo moonInfo;

  /// حجم الودجت (العرض والارتفاع متساويان)
  final double size;

  /// لون طبقة الظل فوق القمر
  final Color overlayColor;

  /// شفافية طبقة الظل (افتراضيًا 0.8)
  final double overlayOpacity;

  /// مسار صورة القمر، بصيغة SVG أو أي صيغة صور يدعمها Flutter.
  final String moonAssetPath;

  /// مسار SVG للخلفية (اختياري)
  final String? backgroundAssetPath;

  /// اسم الحزمة للأصول (افتراضيًا hijri_date)
  final String? assetPackage;

  /// طريقة احتواء صورة القمر
  final BoxFit fit;

  /// استخدام إضاءة مبنية على الطور بدل القيمة الفعلية
  final bool usePhaseBasedIllumination;

  /// نسبة امتلاء دائرة القمر داخل الودجت (0 - 1)
  final double moonScale;

  /// إظهار اسم الطور أسفل القمر (مخفي افتراضيًا).
  final bool showPhaseName;

  /// لغة الاسم: ar أو en. عند عدم تحديدها تُستخدم لغة التطبيق.
  final String? phaseNameLanguage;

  /// نمط اسم الطور، أو نمط النص الافتراضي عند عدم تحديده.
  final TextStyle? phaseNameStyle;

  const MoonPhaseWidget({
    super.key,
    required this.moonInfo,
    this.size = 160,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.8,
    this.moonAssetPath = 'assets/moon.png',
    this.backgroundAssetPath = 'assets/moon_background.svg',
    this.assetPackage = 'hijri_date',
    this.fit = BoxFit.contain,
    this.usePhaseBasedIllumination = false,
    this.moonScale = 0.9,
    this.showPhaseName = false,
    this.phaseNameLanguage,
    this.phaseNameStyle,
  })  : assert(overlayOpacity >= 0 && overlayOpacity <= 1),
        assert(moonScale > 0 && moonScale <= 1);

  @override
  Widget build(BuildContext context) {
    final effectiveIllumination = usePhaseBasedIllumination
        ? _phaseToIllumination(moonInfo.phase)
        : moonInfo.illumination;

    final moon = SizedBox(
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
          if (moonAssetPath.toLowerCase().endsWith('.svg'))
            SvgPicture.asset(
              moonAssetPath,
              package: assetPackage,
              width: size - 30,
              height: size - 30,
              fit: fit,
            )
          else
            Image.asset(
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
                isWaxing: moonInfo.nextFullMoon.isBefore(moonInfo.nextNewMoon),
                illumination: effectiveIllumination,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                moonScale: moonScale,
              ),
            ),
        ],
      ),
    );

    if (!showPhaseName) return moon;

    final language = phaseNameLanguage ??
        Localizations.maybeLocaleOf(context)?.languageCode ??
        'en';
    final name = language.toLowerCase() == 'ar'
        ? moonInfo.arabicName
        : moonInfo.englishName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        moon,
        Text(name, style: phaseNameStyle, textAlign: TextAlign.center),
      ],
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
  final bool isWaxing;
  final double illumination;
  final Color overlayColor;
  final double overlayOpacity;
  final double moonScale;

  const _MoonPhaseOverlayPainter({
    required this.phase,
    required this.isWaxing,
    required this.illumination,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.moonScale,
  });

  bool get _isWaxing {
    if (phase == MoonPhase.newMoon || phase == MoonPhase.fullMoon) {
      return isWaxing;
    }
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
    // The terminator is the projection of a great circle on the lunar disk.
    // Its horizontal radius changes sign at quarter moon.
    final direction = _isWaxing ? 1.0 : -1.0;
    final terminatorX = direction * (1 - 2 * k) * r;
    const control = 0.5522847498307936;
    final shadow = Path()
      ..moveTo(center.dx, center.dy - r)
      ..arcTo(
        Rect.fromCircle(center: center, radius: r),
        -math.pi / 2,
        -direction * math.pi,
        false,
      )
      ..cubicTo(
        center.dx + terminatorX * control,
        center.dy + r,
        center.dx + terminatorX,
        center.dy + r * control,
        center.dx + terminatorX,
        center.dy,
      )
      ..cubicTo(
        center.dx + terminatorX,
        center.dy - r * control,
        center.dx + terminatorX * control,
        center.dy - r,
        center.dx,
        center.dy - r,
      )
      ..close();

    final shadowPaint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.015);
    canvas.save();
    canvas
        .clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: r)));
    canvas.drawPath(shadow, shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MoonPhaseOverlayPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.isWaxing != isWaxing ||
        oldDelegate.moonScale != moonScale ||
        oldDelegate.illumination != illumination ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.overlayOpacity != overlayOpacity;
  }
}
