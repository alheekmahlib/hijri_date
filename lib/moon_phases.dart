/// حساب أطوار القمر (Moon Phases Calculator)
/// يوفر حسابات دقيقة لأطوار القمر المختلفة
library moon_phases;

import 'dart:math' as math;

import 'hijri_date.dart';

/// أطوار القمر المختلفة
enum MoonPhase {
  newMoon, // محاق - القمر الجديد
  waxingCrescent, // هلال متزايد
  firstQuarter, // تربيع أول
  waxingGibbous, // أحدب متزايد
  fullMoon, // بدر - القمر الكامل
  waningGibbous, // أحدب متناقص
  lastQuarter, // تربيع ثاني
  waningCrescent // هلال متناقص
}

/// معلومات طور القمر
class MoonPhaseInfo {
  final MoonPhase phase;
  final double illumination; // نسبة الإضاءة (0.0 - 1.0)
  final double age; // عمر القمر بالأيام
  final DateTime nextFullMoon;
  final DateTime nextNewMoon;
  final String arabicName;
  final String englishName;

  const MoonPhaseInfo({
    required this.phase,
    required this.illumination,
    required this.age,
    required this.nextFullMoon,
    required this.nextNewMoon,
    required this.arabicName,
    required this.englishName,
  });

  @override
  String toString() {
    return 'MoonPhaseInfo{phase: $phase, illumination: ${(illumination * 100).toStringAsFixed(1)}%, age: ${age.toStringAsFixed(1)} days}';
  }
}

/// حاسبة أطوار القمر
class MoonPhaseCalculator {
  /// الأسماء العربية لأطوار القمر
  static const Map<MoonPhase, String> _arabicNames = {
    MoonPhase.newMoon: 'محاق',
    MoonPhase.waxingCrescent: 'هلال متزايد',
    MoonPhase.firstQuarter: 'تربيع أول',
    MoonPhase.waxingGibbous: 'أحدب متزايد',
    MoonPhase.fullMoon: 'بدر',
    MoonPhase.waningGibbous: 'أحدب متناقص',
    MoonPhase.lastQuarter: 'تربيع ثاني',
    MoonPhase.waningCrescent: 'هلال متناقص',
  };

  /// الأسماء الإنجليزية لأطوار القمر
  static const Map<MoonPhase, String> _englishNames = {
    MoonPhase.newMoon: 'New Moon',
    MoonPhase.waxingCrescent: 'Waxing Crescent',
    MoonPhase.firstQuarter: 'First Quarter',
    MoonPhase.waxingGibbous: 'Waxing Gibbous',
    MoonPhase.fullMoon: 'Full Moon',
    MoonPhase.waningGibbous: 'Waning Gibbous',
    MoonPhase.lastQuarter: 'Last Quarter',
    MoonPhase.waningCrescent: 'Waning Crescent',
  };

  static const double _synodicMonth = 29.530588853;
  static const double _degreesToRadians = math.pi / 180;

  static double _sinDegrees(double degrees) =>
      math.sin(degrees * _degreesToRadians);

  /// Approximate geocentric Moon-Sun ecliptic longitude difference in degrees.
  /// The largest lunar perturbations are included; this is not an ephemeris.
  static double _phaseAngle(DateTime date) {
    final days = date.toUtc().microsecondsSinceEpoch / 86400000000 +
        2440587.5 -
        2451545.0;
    final sunMeanLongitude = 280.46646 + 0.98564736 * days;
    final sunAnomaly = 357.52911 + 0.98560028 * days;
    final moonMeanLongitude = 218.31645 + 13.17639648 * days;
    final moonAnomaly = 134.9634 + 13.06499295 * days;
    final elongation = 297.8502 + 12.19074912 * days;
    final latitudeArgument = 93.2721 + 13.22935024 * days;

    final sunLongitude = sunMeanLongitude +
        1.9148 * _sinDegrees(sunAnomaly) +
        0.0200 * _sinDegrees(2 * sunAnomaly);
    final moonLongitude = moonMeanLongitude +
        6.289 * _sinDegrees(moonAnomaly) +
        1.274 * _sinDegrees(2 * elongation - moonAnomaly) +
        0.658 * _sinDegrees(2 * elongation) +
        0.214 * _sinDegrees(2 * moonAnomaly) -
        0.186 * _sinDegrees(sunAnomaly) -
        0.114 * _sinDegrees(2 * latitudeArgument) +
        0.059 * _sinDegrees(2 * elongation - 2 * moonAnomaly) +
        0.057 * _sinDegrees(2 * elongation - sunAnomaly - moonAnomaly) +
        0.053 * _sinDegrees(2 * elongation + moonAnomaly) +
        0.046 * _sinDegrees(2 * elongation - sunAnomaly) +
        0.041 * _sinDegrees(sunAnomaly - moonAnomaly);
    return (moonLongitude - sunLongitude) % 360;
  }

  /// Find a conjunction or opposition by bracketing and bisecting its crossing.
  static DateTime _phaseEvent(DateTime date, double target,
      {bool previous = false}) {
    final direction = previous ? -1 : 1;
    double signedAngle(DateTime time) =>
        ((_phaseAngle(time) - target + 180) % 360) - 180;

    var start = date;
    var startAngle = signedAngle(start);
    for (var i = 0; i < 128; i++) {
      final end = start.add(Duration(hours: 6 * direction));
      final endAngle = signedAngle(end);
      // Reject the discontinuity opposite the requested phase.
      if ((previous
              ? endAngle <= 0 && startAngle >= 0
              : startAngle <= 0 && endAngle >= 0) &&
          (endAngle - startAngle).abs() < 180) {
        var low = previous ? end : start;
        var high = previous ? start : end;
        for (var j = 0; j < 20; j++) {
          final middle = low.add(
              Duration(microseconds: high.difference(low).inMicroseconds ~/ 2));
          if (signedAngle(middle) < 0) {
            low = middle;
          } else {
            high = middle;
          }
        }
        return high;
      }
      start = end;
      startAngle = endAngle;
    }
    throw StateError('Unable to find lunar phase event');
  }

  /// تحديد طور القمر بناءً على العمر
  static MoonPhase _getPhaseFromAge(double moonAge) {
    double normalizedAge = moonAge / _synodicMonth;

    if (normalizedAge < 0.03125 || normalizedAge >= 0.96875) {
      return MoonPhase.newMoon;
    } else if (normalizedAge < 0.21875) {
      return MoonPhase.waxingCrescent;
    } else if (normalizedAge < 0.28125) {
      return MoonPhase.firstQuarter;
    } else if (normalizedAge < 0.46875) {
      return MoonPhase.waxingGibbous;
    } else if (normalizedAge < 0.53125) {
      return MoonPhase.fullMoon;
    } else if (normalizedAge < 0.71875) {
      return MoonPhase.waningGibbous;
    } else if (normalizedAge < 0.78125) {
      return MoonPhase.lastQuarter;
    } else {
      return MoonPhase.waningCrescent;
    }
  }

  /// Calculates an approximate geocentric phase for the supplied instant.
  /// Local and UTC DateTime values representing the same instant give the same result.
  static MoonPhaseInfo getMoonPhase(DateTime date) {
    final angle = _phaseAngle(date);
    final previousNewMoon = _phaseEvent(date, 0, previous: true);
    final moonAge =
        date.difference(previousNewMoon).inMicroseconds / 86400000000;
    // Classification uses elongation, while age is elapsed time since conjunction.
    final phase = _getPhaseFromAge(angle / 360 * _synodicMonth);
    final illumination = (1 - math.cos(angle * _degreesToRadians)) / 2;
    final nextFullMoon = _phaseEvent(date, 180);
    final nextNewMoon = _phaseEvent(date, 0);

    return MoonPhaseInfo(
      phase: phase,
      illumination: illumination,
      age: moonAge,
      nextFullMoon: nextFullMoon,
      nextNewMoon: nextNewMoon,
      arabicName: _arabicNames[phase]!,
      englishName: _englishNames[phase]!,
    );
  }

  /// حساب طور القمر للتاريخ الهجري
  static MoonPhaseInfo getMoonPhaseForHijri(HijriDate hijriDate) {
    return hijriDate.getMoonPhase();
  }

  /// الحصول على جميع تواريخ البدر في سنة هجرية معينة
  static List<HijriDate> getFullMoonDatesInHijriYear(int hijriYear) {
    List<HijriDate> fullMoons = [];

    // البدء من بداية السنة الهجرية
    HijriDate startDate = HijriDate();
    startDate.hYear = hijriYear;
    startDate.hMonth = 1;
    startDate.hDay = 1;

    DateTime startGregorian = startDate.hijriToGregorian(hijriYear, 1, 1);
    DateTime endGregorian = startDate.hijriToGregorian(hijriYear + 1, 1, 1);

    var event = _phaseEvent(startGregorian, 180);
    while (event.isBefore(endGregorian)) {
      fullMoons.add(HijriDate.fromDate(event.toLocal()));
      event = _phaseEvent(event.add(const Duration(minutes: 1)), 180);
    }

    return fullMoons;
  }

  /// الحصول على جميع تواريخ المحاق في سنة هجرية معينة
  static List<HijriDate> getNewMoonDatesInHijriYear(int hijriYear) {
    List<HijriDate> newMoons = [];

    HijriDate startDate = HijriDate();
    startDate.hYear = hijriYear;
    startDate.hMonth = 1;
    startDate.hDay = 1;

    DateTime startGregorian = startDate.hijriToGregorian(hijriYear, 1, 1);
    DateTime endGregorian = startDate.hijriToGregorian(hijriYear + 1, 1, 1);

    var event = _phaseEvent(startGregorian, 0);
    while (event.isBefore(endGregorian)) {
      newMoons.add(HijriDate.fromDate(event.toLocal()));
      event = _phaseEvent(event.add(const Duration(minutes: 1)), 0);
    }

    return newMoons;
  }

  /// تحقق من إمكانية رؤية الهلال
  static bool isHilalVisible(DateTime date, {double minimumAltitude = 10.0}) {
    MoonPhaseInfo moonInfo = getMoonPhase(date);

    // الهلال يمكن رؤيته عادة بعد 18-24 ساعة من المحاق
    // وعندما يكون عمر القمر بين 18 ساعة و 3 أيام
    double ageInHours = moonInfo.age * 24;

    return ageInHours >= 18 && ageInHours <= 72 && moonInfo.illumination > 0.01;
  }

  /// احصائيات أطوار القمر في فترة معينة
  static Map<MoonPhase, int> getMoonPhaseStatistics(
      DateTime startDate, DateTime endDate) {
    Map<MoonPhase, int> statistics = {};

    // تهيئة العداد
    for (MoonPhase phase in MoonPhase.values) {
      statistics[phase] = 0;
    }

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      MoonPhaseInfo moonInfo = getMoonPhase(currentDate);
      statistics[moonInfo.phase] = statistics[moonInfo.phase]! + 1;
      currentDate = currentDate.add(Duration(days: 1));
    }

    return statistics;
  }

  /// الحصول على اسم طور القمر بلغة معينة
  static String getPhaseName(MoonPhase phase, String language) {
    switch (language.toLowerCase()) {
      case 'ar':
      case 'arabic':
        return _arabicNames[phase] ?? '';
      case 'en':
      case 'english':
      default:
        return _englishNames[phase] ?? '';
    }
  }

  /// تحويل طور القمر إلى رقم (0-7)
  static int phaseToNumber(MoonPhase phase) {
    return phase.index;
  }

  /// تحويل رقم إلى طور القمر
  static MoonPhase numberToPhase(int number) {
    if (number < 0 || number >= MoonPhase.values.length) {
      throw ArgumentError(
          'Invalid moon phase number: $number. Must be between 0 and ${MoonPhase.values.length - 1}');
    }
    return MoonPhase.values[number];
  }
}
