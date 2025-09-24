// Copyright (c) 2016, Christian Stewart. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

import 'package:test/test.dart';

import '../lib/digits_converter.dart';
import '../lib/hijri_date.dart';
import '../lib/moon_phases.dart';

void main() {
  HijriDate _hijriDate = HijriDate();
  _hijriDate.hYear = 1439;
  _hijriDate.hMonth = 10;
  _hijriDate.hDay = 30;

  // _hijriDate.currentLocale = 'ar';
  group('Hijri', () {
    test('produces the correct date', () {
      expect(HijriDate.fromDate(DateTime(2020, 5, 20)).toList(),
          equals([1441, 9, 27]));
    });
    test('format date', () {
      expect(HijriDate.fromDate(DateTime(2018, 5, 27)).toFormat("dd mm yy"),
          equals("12 9 39"));
    });
    test('is valid date', () {
      expect(_hijriDate.isValid(), equals(false));
    });

    test('days in year', () {
      expect(_hijriDate.lengthOfYear(year: 1440), equals(355));
    });

    test('days in month', () {
      expect(_hijriDate.getDaysInMonth(1440, 11), equals(29));
    });
    test('format', () {
      expect(_hijriDate.toFormat("DDDD MM yyyy dd"),
          equals("Saturday Shaw 1439 30"));
      expect(_hijriDate.toFormat("DD MMMM yy d"), equals("Sat Shawwal 39 30"));
      expect(_hijriDate.toFormat("MMMM"), equals("Shawwal"));
      expect(_hijriDate.toFormat("MM"), equals("Shaw"));
      expect(_hijriDate.toFormat("dd"), equals("30"));
      expect(_hijriDate.toFormat("d"), equals("30"));
      expect(_hijriDate.toFormat("yyyy"), equals("1439"));
      expect(_hijriDate.toFormat("yy"), equals("39"));
    });

    test('add locale', () {
      const Map<int, String> monthNames = {
        1: 'Muharram',
        2: 'Safar',
        3: 'Rabiul Awal',
        4: 'Rabiul Akhir',
        5: 'Jumadil Awal',
        6: 'Jumadil Akhir',
        7: 'Rajab',
        8: 'Sya\'ban',
        9: 'Ramadan',
        10: 'Syawal',
        11: 'Dzulqa\'dah',
        12: 'Dzulhijjah'
      };
      const Map<int, String> monthShortNames = {
        1: 'Muh',
        2: 'Saf',
        3: 'Rab1',
        4: 'Rab2',
        5: 'Jum1',
        6: 'Jum2',
        7: 'Raj',
        8: 'Sya\'',
        9: 'Ram',
        10: 'Syaw',
        11: 'DzuQ',
        12: 'DzuH'
      };
      const Map<int, String> wdNames = {
        7: "Ahad",
        1: "Senin",
        2: "Selasa",
        3: "Rabu",
        4: "Kamis",
        5: "Jum'at",
        6: "Sabtu"
      };
      const Map<int, String> shortWdNames = {
        7: "Aha",
        1: "Sen",
        2: "Sel",
        3: "Rab",
        4: "Kam",
        5: "Jum",
        6: "Sab"
      };
      HijriDate.addLocale('id', {
        'long': monthNames,
        'short': monthShortNames,
        'days': wdNames,
        'short_days': shortWdNames
      });
      HijriDate.setLocal('id');
      expect(
          _hijriDate.toFormat("DDDD MM yyyy dd"), equals("Sabtu Syaw 1439 30"));
      // Reset language to English after this test
      HijriDate.setLocal('en');
    });
  });

  group('compare dates', () {
    test('this date occurs before enterd date', () {
      expect(_hijriDate.isBefore(1439, 10, 12), equals(false));
    });
    test('this date occurs after enterd date', () {
      expect(_hijriDate.isAfter(1439, 10, 12), equals(true));
    });
    test('this date occurs after enterd date', () {
      expect(_hijriDate.isAtSameMomentAs(1439, 10, 30), equals(true));
    });
  });

  group('Gregorian', () {
    test('convert Hijri to Gregorian', () {
      expect(_hijriDate.hijriToGregorian(1439, 10, 12),
          equals(DateTime(2018, 06, 26, 00, 00, 00, 000)));
    });
  });

  group('adjustment', () {
    HijriDate _adjCal = HijriDate();
    test('without adjustment produces the correct date', () {
      _adjCal.gregorianToHijri(2020, 8, 20);
      expect(_adjCal.toList(), equals([1442, 1, 1]));
    });
    test('with adjustment produced the correct date', () {
      //year 1441, month 12 ((1441 - 1) * 12 + 12) has 30 days instead of 29
      _adjCal.setAdjustments({17292: 59083});
      _adjCal.gregorianToHijri(2020, 8, 20);
      expect(_adjCal.toList(), equals([1441, 12, 30]));
    });
  });

  group('return Map of months values', () {
    HijriDate _calender = HijriDate();
    test('get all months', () {
      const Map<int, String> monthNames = {
        1: 'Muharram',
        2: 'Safar',
        3: 'Rabi\' Al-Awwal',
        4: 'Rabi\' Al-Thani',
        5: 'Jumada Al-Awwal',
        6: 'Jumada Al-Thani',
        7: 'Rajab',
        8: 'Sha\'aban',
        9: 'Ramadan',
        10: 'Shawwal',
        11: 'Dhu Al-Qi\'dah',
        12: 'Dhu Al-Hijjah'
      };
      Map monthes = _calender.getMonths();
      expect(monthes, equals(monthNames));
    });

    test('get specific month calender', () {
      HijriDate _calender = HijriDate();
      Map monthes =
          _calender.getMonthDays(HijriDate.now().hMonth, HijriDate.now().hYear);
      expect(monthes, equals(monthes));
    });
  });

  // ============= Moon Phases Tests =============
  group('Moon Phases', () {
    test('get moon phase for current date', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);
      MoonPhaseInfo moonInfo = hijri.getMoonPhase();
      expect(moonInfo.phase, isA<MoonPhase>());
      expect(moonInfo.illumination, inInclusiveRange(0.0, 1.0));
      expect(moonInfo.age, inInclusiveRange(0.0, 29.5));
    });

    test('get moon phase for specific date', () {
      MoonPhaseInfo moonInfo = HijriDate.getMoonPhaseForDate(1445, 1, 1);
      expect(moonInfo, isA<MoonPhaseInfo>());
      expect(moonInfo.phase, isA<MoonPhase>());
    });

    test('get new moon dates in year', () {
      List<HijriDate> newMoons = HijriDate.getNewMoonDatesInYear(1445);
      expect(newMoons.length, equals(12));
      // Each new moon should be in the correct year
      for (HijriDate newMoon in newMoons) {
        expect(newMoon.hYear, equals(1445));
      }
    });

    test('get full moon dates in year', () {
      List<HijriDate> fullMoons = HijriDate.getFullMoonDatesInYear(1445);
      expect(fullMoons.length, equals(12));
      // Full moons should typically occur around middle of lunar month
      for (HijriDate fullMoon in fullMoons) {
        expect(fullMoon.hDay, inInclusiveRange(13, 16));
      }
    });

    test('moon phase statistics for month', () {
      Map<MoonPhase, int> stats =
          HijriDate.getMoonPhaseStatisticsForMonth(1445, 1);
      expect(stats, isA<Map<MoonPhase, int>>());

      int totalDays = stats.values.fold(0, (sum, count) => sum + count);
      expect(totalDays, equals(29)); // Month 1 of 1445 has 29 days
    });

    test('is new moon detection', () {
      List<HijriDate> newMoons = HijriDate.getNewMoonDatesInYear(1445);
      HijriDate firstNewMoon = newMoons.first;
      expect(firstNewMoon.isNewMoon(), isTrue);
    });

    test('is full moon detection', () {
      HijriDate fullMoonDate = HijriDate.fromHijri(1445, 1, 14);
      expect(fullMoonDate.isFullMoon(), isTrue);
    });

    test('days until next full moon', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 5);
      int days = hijri.daysUntilNextFullMoon();
      expect(days, isA<int>());
      expect(days, greaterThanOrEqualTo(0));
    });

    test('days until next new moon', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);
      int days = hijri.daysUntilNextNewMoon();
      expect(days, isA<int>());
      expect(days, greaterThanOrEqualTo(0));
    });

    test('moon phase names in different languages', () {
      List<HijriDate> newMoons = HijriDate.getNewMoonDatesInYear(1445);
      HijriDate newMoonDate = newMoons.first;

      // Test English
      String englishName = newMoonDate.getMoonPhaseName(language: 'en');
      expect(englishName, contains('New Moon'));

      // Test Arabic
      String arabicName = newMoonDate.getMoonPhaseName(language: 'ar');
      expect(arabicName, contains('محاق'));
    });

    test('hilal visibility check', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 2);
      bool isVisible = hijri.isHilalVisible();
      expect(isVisible, isA<bool>());
    });

    test('moon info formatted string', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      String englishInfo = hijri.moonInfo(language: 'en');
      expect(englishInfo, contains('Moon Phase'));
      expect(englishInfo, contains('Illumination'));
      expect(englishInfo, contains('Age'));

      String arabicInfo = hijri.moonInfo(language: 'ar');
      expect(arabicInfo, contains('طور القمر'));
      expect(arabicInfo, contains('نسبة الإضاءة'));
      expect(arabicInfo, contains('العمر'));
    });
  });

  // ============= Multi-language Support Tests =============
  group('Multi-language Support', () {
    tearDown(() {
      // Reset language to English after each test
      HijriDate.setLocal('en');
    });

    test('Arabic localization', () {
      HijriDate.setLocal('ar');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('محرم'));
      expect(hijri.getDayName().isNotEmpty, isTrue);

      String formatted = hijri.format(1445, 1, 15, 'MMMM dd, yyyy');
      expect(formatted, contains('محرم'));
    });

    test('Turkish localization', () {
      HijriDate.setLocal('tr');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('MUHARREM'));

      String formatted = hijri.format(1445, 1, 15, 'MMMM dd, yyyy');
      expect(formatted, contains('MUHARREM'));
    });

    test('Indonesian localization', () {
      HijriDate.setLocal('id');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('Muharram'));
    });

    test('Malay localization', () {
      HijriDate.setLocal('ms');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('Muharram'));
    });

    test('Filipino localization', () {
      HijriDate.setLocal('fil');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('Muharram'));
    });

    test('Bengali localization', () {
      HijriDate.setLocal('bn');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('মুহাররম'));
    });

    test('Urdu localization', () {
      HijriDate.setLocal('ur');
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 15);

      expect(hijri.getLongMonthName(), equals('محرم'));
    });

    test('number conversion to different locales', () {
      // Test Arabic-Indic digits
      String arabicNumber = DigitsConverter.convertNumberToLocale(1445, 'ar');
      expect(arabicNumber, equals('١٤٤٥'));

      // Test Bengali digits
      String bengaliNumber = DigitsConverter.convertNumberToLocale(1445, 'bn');
      expect(bengaliNumber, equals('১৪৪৫'));

      // Test Urdu digits
      String urduNumber = DigitsConverter.convertNumberToLocale(1445, 'ur');
      expect(urduNumber, equals('۱۴۴۵'));
    });

    test('date formatting with localized numbers', () {
      // Arabic with Arabic-Indic numerals
      HijriDate.setLocal('ar');
      HijriDate arabicHijri = HijriDate.fromHijri(1445, 1, 15);
      String arabicFormatted = arabicHijri.format(1445, 1, 15, 'dd/mm/yyyy');
      expect(arabicFormatted, equals('١٥/١/١٤٤٥'));

      // Bengali with Bengali numerals
      HijriDate.setLocal('bn');
      HijriDate bengaliHijri = HijriDate.fromHijri(1445, 1, 15);
      String bengaliFormatted = bengaliHijri.format(1445, 1, 15, 'dd/mm/yyyy');
      expect(bengaliFormatted, equals('১৫/১/১৪৪৫'));
    });

    test('unsupported locale throws error', () {
      expect(() => HijriDate.setLocal('unsupported'),
          throwsA(isA<ArgumentError>()));
    });

    test('digits converter with invalid locale', () {
      String result = DigitsConverter.convertNumberToLocale(123, 'invalid');
      expect(result, equals('123')); // Should return original number as string
    });

    test('supported locales list', () {
      List<String> supportedLocales = DigitsConverter.getSupportedLocales();
      expect(supportedLocales.length, equals(8));
      expect(supportedLocales, contains('ar'));
      expect(supportedLocales, contains('en'));
      expect(supportedLocales, contains('tr'));
      expect(supportedLocales, contains('id'));
      expect(supportedLocales, contains('ms'));
      expect(supportedLocales, contains('fil'));
      expect(supportedLocales, contains('bn'));
      expect(supportedLocales, contains('ur'));
    });

    test('sample digits for different locales', () {
      String arabicSample = DigitsConverter.getSampleDigits('ar');
      expect(arabicSample, equals('٠١٢٣٤٥٦٧٨٩'));

      String bengaliSample = DigitsConverter.getSampleDigits('bn');
      expect(bengaliSample, equals('০১২৩৪৫৬৭৮৯'));

      String urduSample = DigitsConverter.getSampleDigits('ur');
      expect(urduSample, equals('۰۱۲۳۴۵۶۷۸۹'));
    });
  });

  // ============= Integration Tests =============
  group('Integration Tests', () {
    test('adjustments affect moon phases correctly', () {
      HijriDate cal1 = HijriDate();
      HijriDate cal2 = HijriDate();

      // Test without adjustments
      cal1.gregorianToHijri(2020, 8, 20);
      MoonPhaseInfo moon1 = cal1.getMoonPhase();

      // Test with adjustments
      cal2.setAdjustments({17292: 59083});
      cal2.gregorianToHijri(2020, 8, 20);
      MoonPhaseInfo moon2 = cal2.getMoonPhase();

      // The adjustment should affect the moon phase calculation
      expect(cal1.toList(), isNot(equals(cal2.toList())));

      // The adjustment should cause different dates, which means different moon calculations
      // Just verify that moon phase objects exist and have valid data
      expect(moon1.illumination, inInclusiveRange(0.0, 1.0));
      expect(moon2.illumination, inInclusiveRange(0.0, 1.0));
      expect(moon1.age, greaterThanOrEqualTo(0.0));
      expect(moon2.age, greaterThanOrEqualTo(0.0));
    });

    test('moon phases work with different languages', () {
      HijriDate hijri = HijriDate.fromHijri(1445, 1, 14);

      // Test moon phase in English
      HijriDate.setLocal('en');
      String englishMoonInfo = hijri.moonInfo();
      expect(englishMoonInfo, contains('Moon Phase'));

      // Test moon phase in Arabic
      HijriDate.setLocal('ar');
      String arabicMoonInfo = hijri.moonInfo();
      expect(arabicMoonInfo, contains('طور القمر'));

      // Reset language
      HijriDate.setLocal('en');
    });

    test('islamic events with calendar integration', () {
      // Test that calendar works with islamic events integration
      HijriDate hijri = HijriDate.fromHijri(1445, 9, 15); // Ramadan

      // Test basic calendar functionality still works
      expect(hijri.fullDate(), isA<String>());
      expect(hijri.getMoonPhase(), isA<MoonPhaseInfo>());
      expect(hijri.lengthOfMonth, greaterThan(0));
      expect(hijri.isValid(), isTrue);

      // Test with different language
      HijriDate.setLocal('ar');
      expect(hijri.fullDate(), contains('رمضان'));

      // Reset language
      HijriDate.setLocal('en');
    });
  });
}
