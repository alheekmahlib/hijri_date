import 'package:test/test.dart';

import '../lib/hijri_calendar.dart';
import '../lib/hijri_utils.dart';

void main() {
  group('Enhanced HijriCalendar Tests', () {
    late HijriCalendar testDate;

    setUp(() {
      testDate = HijriCalendar.fromHijri(1445, 6, 15);
    });

    test('Test new properties', () {
      expect(testDate.isLeapYear, isA<bool>());
      expect(testDate.dayOfYear, greaterThan(0));
      expect(testDate.weekOfYear, greaterThan(0));
      expect(testDate.isWeekend, isA<bool>());
      expect(testDate.isoFormat, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test('Test date arithmetic', () {
      final tomorrow = testDate.addDays(1);
      expect(tomorrow.hDay, equals(16));

      final nextMonth = testDate.addMonths(1);
      expect(nextMonth.hMonth, equals(7));

      final nextYear = testDate.addYears(1);
      expect(nextYear.hYear, equals(1446));
    });

    test('Test comparison operators', () {
      final laterDate = testDate.addDays(5);
      expect(testDate < laterDate, isTrue);
      expect(laterDate > testDate, isTrue);
      expect(testDate <= testDate, isTrue);
      expect(testDate >= testDate, isTrue);
    });

    test('Test equality and hash code', () {
      final sameDate = HijriCalendar.fromHijri(1445, 6, 15);
      expect(testDate == sameDate, isTrue);
      expect(testDate.hashCode == sameDate.hashCode, isTrue);
    });

    test('Test JSON serialization', () {
      final json = testDate.toJson();
      final fromJson = HijriCalendar.fromJson(json);
      expect(fromJson, equals(testDate));
    });

    test('Test age calculation', () {
      final birthDate = HijriCalendar.fromHijri(1400, 1, 1);
      final age = birthDate.ageInYears();
      expect(age, greaterThan(0));
    });

    test('Test date range operations', () {
      expect(
          testDate.isSameMonth(HijriCalendar.fromHijri(1445, 6, 20)), isTrue);
      expect(testDate.isSameYear(HijriCalendar.fromHijri(1445, 12, 1)), isTrue);

      final datesInMonth = testDate.getDatesInMonth();
      expect(datesInMonth.length, equals(testDate.lengthOfMonth));
    });
  });

  group('HijriUtils Tests', () {
    test('Test Islamic events', () {
      final newYear = HijriCalendar.fromHijri(1445, 1, 1);
      final event = IslamicEvents.getEventForDate(newYear);
      expect(event, isNotNull);
      expect(event!['nameEn'], equals('Islamic New Year'));
    });

    test('Test prayer time helper', () {
      final ashuraDate = HijriCalendar.fromHijri(1445, 1, 10);
      expect(PrayerTimeHelper.isRecommendedFastingDay(ashuraDate), isTrue);
    });

    test('Test season calculation', () {
      final ramadanDate = HijriCalendar.fromHijri(1445, 9, 15);
      final season = HijriUtils.getSeason(ramadanDate.hMonth);
      expect(season, equals('Spring'));
    });

    test('Test date range generation', () {
      final start = HijriCalendar.fromHijri(1445, 1, 1);
      final end = HijriCalendar.fromHijri(1445, 1, 5);
      final range = HijriUtils.getDateRange(start, end);
      expect(range.length, equals(5));
    });

    test('Test Friday calculation', () {
      final fridays = HijriUtils.getFridaysInMonth(1445, 1);
      expect(fridays.every((date) => date.wkDay == 5), isTrue);
    });
  });

  group('Age Calculator Tests', () {
    test('Test detailed age calculation', () {
      final birthDate = HijriCalendar.fromHijri(1400, 6, 15);
      final currentDate = HijriCalendar.fromHijri(1445, 8, 20);
      final age = AgeCalculator.calculateDetailedAge(birthDate, currentDate);

      expect(age['years'], greaterThan(40));
      expect(age['months'], isA<int>());
      expect(age['days'], isA<int>());
    });

    test('Test age category', () {
      final category = AgeCalculator.getAgeCategory(25);
      expect(category, equals('Adult'));

      final categoryAr = AgeCalculator.getAgeCategory(25, 'ar');
      expect(categoryAr, equals('بالغ'));
    });
  });

  group('Enhanced Validation Tests', () {
    test('Test improved validation', () {
      // Test invalid year
      expect(() => HijriCalendar.fromHijri(1300, 1, 1),
          throwsA(isA<ArgumentError>()));

      // Test invalid day for month
      expect(() => HijriCalendar.fromHijri(1445, 2, 31),
          throwsA(isA<ArgumentError>()));
    });

    test('Test locale validation', () {
      expect(() => HijriCalendar.setLocal('invalid_locale'),
          throwsA(isA<ArgumentError>()));
    });
  });

  group('Performance and Edge Cases', () {
    test('Test large date ranges', () {
      final start = HijriCalendar.fromHijri(1356, 1, 1);
      final end = HijriCalendar.fromHijri(1500, 12, 29);

      expect(() => start.differenceInDays(end), returnsNormally);
    });

    test('Test boundary dates', () {
      // Test minimum supported date
      expect(() => HijriCalendar.fromHijri(1356, 1, 1), returnsNormally);

      // Test maximum supported date
      expect(() => HijriCalendar.fromHijri(1500, 12, 29), returnsNormally);
    });

    test('Test month transitions', () {
      final endOfMonth = HijriCalendar.fromHijri(1445, 6, 29);
      final nextDay = endOfMonth.addDays(1);
      expect(nextDay.hMonth, equals(7));
      expect(nextDay.hDay, equals(1));
    });

    test('Test year transitions', () {
      final endOfYear = HijriCalendar.fromHijri(1444, 12, 29);
      final nextDay = endOfYear.addDays(1);
      expect(nextDay.hYear, equals(1445));
      expect(nextDay.hMonth, equals(1));
    });
  });
}
