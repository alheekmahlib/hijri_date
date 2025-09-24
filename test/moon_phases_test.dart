import 'package:test/test.dart';

import '../lib/hijri_calendar.dart';
import '../lib/moon_phases.dart';

void main() {
  group('Moon Phases Tests', () {
    test('Get moon phase for specific date', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 15);
      var moonInfo = hijriDate.getMoonPhase();

      expect(moonInfo, isA<MoonPhaseInfo>());
      expect(moonInfo.phase, isA<MoonPhase>());
      expect(moonInfo.illumination, greaterThanOrEqualTo(0.0));
      expect(moonInfo.illumination, lessThanOrEqualTo(1.0));
      expect(moonInfo.age, greaterThanOrEqualTo(0.0));
      expect(moonInfo.age, lessThanOrEqualTo(29.6));
    });

    test('Get moon phase name in different languages', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

      // Test Arabic name
      HijriCalendar.setLocal('ar');
      var arabicName = hijriDate.getMoonPhaseName();
      expect(arabicName, isNotEmpty);

      // Test English name
      HijriCalendar.setLocal('en');
      var englishName = hijriDate.getMoonPhaseName();
      expect(englishName, isNotEmpty);

      // Arabic and English names should be different
      expect(arabicName, isNot(equals(englishName)));
    });

    test('Get full moon dates in Hijri year', () {
      var fullMoons = HijriCalendar.getFullMoonDatesInYear(1445);

      expect(fullMoons, isA<List<HijriCalendar>>());
      expect(fullMoons.length, greaterThan(0));
      expect(
          fullMoons.length,
          lessThanOrEqualTo(
              15)); // Allow for more transitions due to calculation method

      // Check that all returned dates are valid
      for (var date in fullMoons) {
        expect(date.isValid(), isTrue);
        expect(date.hYear, equals(1445));
      }
    });

    test('Get new moon dates in Hijri year', () {
      var newMoons = HijriCalendar.getNewMoonDatesInYear(1445);

      expect(newMoons, isA<List<HijriCalendar>>());
      expect(newMoons.length, greaterThan(0));
      expect(
          newMoons.length,
          lessThanOrEqualTo(
              15)); // Allow for more transitions due to calculation method

      // Check that all returned dates are valid
      for (var date in newMoons) {
        expect(date.isValid(), isTrue);
        expect(date.hYear, equals(1445));
      }
    });

    test('Check hilal visibility', () {
      // Test with a date that should have hilal visible
      var hijriDate =
          HijriCalendar.fromHijri(1445, 1, 2); // Second day of month
      var isVisible = hijriDate.isHilalVisible();

      expect(isVisible, isA<bool>());
    });

    test('Moon phase statistics for month', () {
      var stats = HijriCalendar.getMoonPhaseStatisticsForMonth(1445, 9);

      expect(stats, isA<Map<MoonPhase, int>>());
      expect(stats.keys.length, equals(MoonPhase.values.length));

      // Total days should equal days in month
      int totalDays = stats.values.reduce((a, b) => a + b);
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 1);
      int daysInMonth = hijriDate.getDaysInMonth(1445, 9);
      expect(totalDays, equals(daysInMonth));
    });

    test('Check if date is full moon', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 15);
      var isFullMoon = hijriDate.isFullMoon();

      expect(isFullMoon, isA<bool>());
    });

    test('Check if date is new moon', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 1);
      var isNewMoon = hijriDate.isNewMoon();

      expect(isNewMoon, isA<bool>());
    });

    test('Days until next full moon', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 10);
      var days = hijriDate.daysUntilNextFullMoon();

      expect(days, isA<int>());
      expect(days, greaterThanOrEqualTo(0));
      expect(days, lessThanOrEqualTo(29)); // Maximum lunar cycle days
    });

    test('Days until next new moon', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 10);
      var days = hijriDate.daysUntilNextNewMoon();

      expect(days, isA<int>());
      expect(days, greaterThanOrEqualTo(0));
      expect(days, lessThanOrEqualTo(29)); // Maximum lunar cycle days
    });

    test('Moon info string', () {
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

      // Test English info
      HijriCalendar.setLocal('en');
      var englishInfo = hijriDate.moonInfo();
      expect(englishInfo, contains('Moon Phase'));
      expect(englishInfo, contains('Illumination'));
      expect(englishInfo, contains('Age'));

      // Test Arabic info
      HijriCalendar.setLocal('ar');
      var arabicInfo = hijriDate.moonInfo();
      expect(arabicInfo, contains('طور القمر'));
      expect(arabicInfo, contains('نسبة الإضاءة'));
      expect(arabicInfo, contains('العمر'));

      // Reset to English
      HijriCalendar.setLocal('en');
    });

    test('Moon phase conversion functions', () {
      // Test phase to number conversion
      expect(MoonPhaseCalculator.phaseToNumber(MoonPhase.newMoon), equals(0));
      expect(MoonPhaseCalculator.phaseToNumber(MoonPhase.fullMoon), equals(4));

      // Test number to phase conversion
      expect(MoonPhaseCalculator.numberToPhase(0), equals(MoonPhase.newMoon));
      expect(MoonPhaseCalculator.numberToPhase(4), equals(MoonPhase.fullMoon));

      // Test invalid number
      expect(() => MoonPhaseCalculator.numberToPhase(-1), throwsArgumentError);
      expect(() => MoonPhaseCalculator.numberToPhase(8), throwsArgumentError);
    });

    test('Moon phase names in different languages', () {
      // Test English names
      expect(MoonPhaseCalculator.getPhaseName(MoonPhase.newMoon, 'en'),
          equals('New Moon'));
      expect(MoonPhaseCalculator.getPhaseName(MoonPhase.fullMoon, 'en'),
          equals('Full Moon'));

      // Test Arabic names
      expect(MoonPhaseCalculator.getPhaseName(MoonPhase.newMoon, 'ar'),
          equals('محاق'));
      expect(MoonPhaseCalculator.getPhaseName(MoonPhase.fullMoon, 'ar'),
          equals('بدر'));
    });

    test('Static moon phase methods', () {
      // Test static method for getting moon phase
      var moonInfo = HijriCalendar.getMoonPhaseForDate(1445, 9, 15);
      expect(moonInfo, isA<MoonPhaseInfo>());

      // Test static method for hilal visibility
      var isVisible = HijriCalendar.isHilalVisibleForDate(1445, 1, 2);
      expect(isVisible, isA<bool>());
    });

    test('Moon phase calculation accuracy', () {
      // Test with known historical dates
      var hijriDate = HijriCalendar.fromHijri(1445, 9, 1); // First of Ramadan
      var moonInfo = hijriDate.getMoonPhase();

      // The first day of an Islamic month should be close to new moon
      expect(moonInfo.age, lessThan(3.0)); // Should be less than 3 days old
    });

    test('Edge cases for moon phase calculations', () {
      // Test with very early Hijri date
      var earlyDate = HijriCalendar.fromHijri(1356, 1, 1);
      var moonInfo = earlyDate.getMoonPhase();
      expect(moonInfo, isA<MoonPhaseInfo>());

      // Test with far future date (within valid range)
      var futureDate = HijriCalendar.fromHijri(1499, 12, 29);
      var moonInfo2 = futureDate.getMoonPhase();
      expect(moonInfo2, isA<MoonPhaseInfo>());
    });
  });
}
