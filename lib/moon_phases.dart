/// حساب أطوار القمر (Moon Phases Calculator)
/// يوفر حسابات دقيقة لأطوار القمر المختلفة
library moon_phases;

import 'dart:math' as math;

import 'hijri_calendar.dart';

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

  /// حساب Julian Day Number
  static double _getJulianDayNumber(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    double hour = date.hour + date.minute / 60.0 + date.second / 3600.0;

    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    double a = (year / 100.0).floor().toDouble();
    double b = 2 - a + (a / 4.0).floor();

    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        hour / 24.0 +
        b -
        1524.5;
  }

  /// حساب عمر القمر بالأيام منذ المحاق الأخير
  static double _getMoonAge(DateTime date) {
    double jd = _getJulianDayNumber(date);

    // تاريخ محاق مرجعي معروف: 6 يناير 2000, 18:14 UTC
    double knownNewMoonJD = 2451550.1;

    // الدورة القمرية المتوسطة
    double synodicMonth = 29.530588853;

    double daysSinceKnownNewMoon = jd - knownNewMoonJD;
    double lunationsSinceKnown = daysSinceKnownNewMoon / synodicMonth;

    // عمر القمر هو الجزء العشري من الدورات مضروباً في طول الدورة
    double moonAge =
        (lunationsSinceKnown - lunationsSinceKnown.floor()) * synodicMonth;

    return moonAge;
  }

  /// حساب نسبة الإضاءة
  static double _getIllumination(double moonAge) {
    double synodicMonth = 29.530588853;
    double phase = moonAge / synodicMonth;

    // حساب نسبة الإضاءة بناءً على الطور
    return (1 - math.cos(2 * math.pi * phase)) / 2;
  }

  /// تحديد طور القمر بناءً على العمر
  static MoonPhase _getPhaseFromAge(double moonAge) {
    double synodicMonth = 29.530588853;
    double normalizedAge = moonAge / synodicMonth;

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

  /// حساب تاريخ البدر التالي
  static DateTime _getNextFullMoon(DateTime date, double moonAge) {
    double synodicMonth = 29.530588853;
    double daysToFullMoon;

    if (moonAge <= synodicMonth / 2) {
      // إذا كان القمر في النصف الأول من الدورة
      daysToFullMoon = (synodicMonth / 2) - moonAge;
    } else {
      // إذا كان القمر في النصف الثاني من الدورة
      daysToFullMoon = synodicMonth - moonAge + (synodicMonth / 2);
    }

    return date.add(Duration(days: daysToFullMoon.round()));
  }

  /// حساب تاريخ المحاق التالي
  static DateTime _getNextNewMoon(DateTime date, double moonAge) {
    double synodicMonth = 29.530588853;
    double daysToNewMoon = synodicMonth - moonAge;

    return date.add(Duration(days: daysToNewMoon.round()));
  }

  /// حساب طور القمر لتاريخ معين
  static MoonPhaseInfo getMoonPhase(DateTime date) {
    double moonAge = _getMoonAge(date);
    MoonPhase phase = _getPhaseFromAge(moonAge);
    double illumination = _getIllumination(moonAge);
    DateTime nextFullMoon = _getNextFullMoon(date, moonAge);
    DateTime nextNewMoon = _getNextNewMoon(date, moonAge);

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
  static MoonPhaseInfo getMoonPhaseForHijri(HijriCalendar hijriDate) {
    DateTime gregorianDate = hijriDate.hijriToGregorian(
        hijriDate.hYear, hijriDate.hMonth, hijriDate.hDay);
    return getMoonPhase(gregorianDate);
  }

  /// الحصول على جميع تواريخ البدر في سنة هجرية معينة
  static List<HijriCalendar> getFullMoonDatesInHijriYear(int hijriYear) {
    List<HijriCalendar> fullMoons = [];

    // البدء من بداية السنة الهجرية
    HijriCalendar startDate = HijriCalendar();
    startDate.hYear = hijriYear;
    startDate.hMonth = 1;
    startDate.hDay = 1;

    DateTime startGregorian = startDate.hijriToGregorian(hijriYear, 1, 1);
    DateTime endGregorian = startDate.hijriToGregorian(hijriYear + 1, 1, 1);

    DateTime currentDate = startGregorian;
    MoonPhase? lastPhase;

    while (currentDate.isBefore(endGregorian)) {
      MoonPhaseInfo moonInfo = getMoonPhase(currentDate);

      // Add only when transitioning to full moon (to avoid duplicate consecutive days)
      if (moonInfo.phase == MoonPhase.fullMoon &&
          lastPhase != MoonPhase.fullMoon) {
        HijriCalendar hijriFullMoon = HijriCalendar.fromDate(currentDate);
        fullMoons.add(hijriFullMoon);
      }

      lastPhase = moonInfo.phase;
      currentDate = currentDate.add(Duration(days: 1));
    }

    return fullMoons;
  }

  /// الحصول على جميع تواريخ المحاق في سنة هجرية معينة
  static List<HijriCalendar> getNewMoonDatesInHijriYear(int hijriYear) {
    List<HijriCalendar> newMoons = [];

    HijriCalendar startDate = HijriCalendar();
    startDate.hYear = hijriYear;
    startDate.hMonth = 1;
    startDate.hDay = 1;

    DateTime startGregorian = startDate.hijriToGregorian(hijriYear, 1, 1);
    DateTime endGregorian = startDate.hijriToGregorian(hijriYear + 1, 1, 1);

    DateTime currentDate = startGregorian;
    MoonPhase? lastPhase;

    while (currentDate.isBefore(endGregorian)) {
      MoonPhaseInfo moonInfo = getMoonPhase(currentDate);

      // Add only when transitioning to new moon (to avoid duplicate consecutive days)
      if (moonInfo.phase == MoonPhase.newMoon &&
          lastPhase != MoonPhase.newMoon) {
        HijriCalendar hijriNewMoon = HijriCalendar.fromDate(currentDate);
        newMoons.add(hijriNewMoon);
      }

      lastPhase = moonInfo.phase;
      currentDate = currentDate.add(Duration(days: 1));
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
