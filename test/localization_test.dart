import 'package:test/test.dart';

import '../lib/convert_number_extension.dart';
import '../lib/digits_converter.dart';
import '../lib/hijri_calendar.dart';

void main() {
  group('Localization and Number Conversion Tests', () {
    late HijriCalendar hijriDate;

    setUp(() {
      hijriDate = HijriCalendar();
      hijriDate.hYear = 1445;
      hijriDate.hMonth = 9; // Ramadan
      hijriDate.hDay = 15;
    });

    tearDown(() {
      // Reset to English after each test
      HijriCalendar.setLocal('en');
    });

    group('Supported Locales', () {
      test('should support all new locales', () {
        List<String> supportedLocales = [
          'en',
          'ar',
          'tr',
          'id',
          'ms',
          'fil',
          'bn',
          'ur'
        ];

        for (String locale in supportedLocales) {
          expect(() => HijriCalendar.setLocal(locale), returnsNormally);
        }
      });

      test('should throw error for unsupported locale', () {
        expect(() => HijriCalendar.setLocal('xx'), throwsArgumentError);
      });
    });

    group('Number Conversion', () {
      test('Arabic numbers conversion', () {
        String result = DigitsConverter.convertNumberToLocale(12345, 'ar');
        expect(result, equals('١٢٣٤٥'));
      });

      test('Bengali numbers conversion', () {
        String result = DigitsConverter.convertNumberToLocale(12345, 'bn');
        expect(result, equals('১২৩৪৫'));
      });

      test('Urdu numbers conversion', () {
        String result = DigitsConverter.convertNumberToLocale(12345, 'ur');
        expect(result, equals('۱۲۳۴۵'));
      });

      test('Western numbers (Indonesian, Malay, Filipino, Turkish, English)',
          () {
        List<String> westernLocales = ['en', 'id', 'ms', 'fil', 'tr'];

        for (String locale in westernLocales) {
          String result = DigitsConverter.convertNumberToLocale(12345, locale);
          expect(result, equals('12345'));
        }
      });

      test('negative numbers conversion', () {
        String result = DigitsConverter.convertNumberToLocale(-123, 'ar');
        expect(result, equals('-١٢٣'));
      });

      test('sample digits for all locales', () {
        expect(DigitsConverter.getSampleDigits('ar'), equals('٠١٢٣٤٥٦٧٨٩'));
        expect(DigitsConverter.getSampleDigits('bn'), equals('০১২৩৪৫৬৭৮৯'));
        expect(DigitsConverter.getSampleDigits('ur'), equals('۰۱۲۳۴۵۶۷۸۹'));
        expect(DigitsConverter.getSampleDigits('en'), equals('0123456789'));
      });
    });

    group('String Extension Number Conversion', () {
      test('Arabic string conversion', () {
        expect('12345'.convertNumbers('ar'), equals('١٢٣٤٥'));
      });

      test('Bengali string conversion', () {
        expect('12345'.convertNumbers('bn'), equals('১২৩৪৫'));
      });

      test('Urdu string conversion', () {
        expect('12345'.convertNumbers('ur'), equals('۱۲۳۴۵'));
      });

      test('Mixed content conversion', () {
        expect('Today is 15/9/1445'.convertNumbers('ar'),
            equals('Today is ١٥/٩/١٤٤٥'));
      });
    });

    group('Indonesian Localization', () {
      test('Indonesian month names', () {
        HijriCalendar.setLocal('id');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getLongMonthName(), equals('Ramadan'));
        expect(hijriDate.getShortMonthName(), equals('Ram'));
        expect(hijriDate.toFormat('MMMM dd, yyyy'), equals('Ramadan 15, 1445'));
      });

      test('Indonesian weekday names', () {
        HijriCalendar.setLocal('id');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getDayName(), isA<String>());
        String dayName = hijriDate.toFormat('DDDD');
        expect(dayName, isNotEmpty);
      });
    });

    group('Malay Localization', () {
      test('Malay month names', () {
        HijriCalendar.setLocal('ms');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getLongMonthName(), equals('Ramadan'));
        expect(hijriDate.getShortMonthName(), equals('Ram'));
      });

      test('Malay weekday names', () {
        HijriCalendar.setLocal('ms');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        String dayName = hijriDate.toFormat('DDDD');
        expect(dayName, isNotEmpty);
      });
    });

    group('Filipino Localization', () {
      test('Filipino month names', () {
        HijriCalendar.setLocal('fil');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getLongMonthName(), equals('Ramadan'));
        expect(hijriDate.getShortMonthName(), equals('Ram'));
      });

      test('Filipino weekday names', () {
        HijriCalendar.setLocal('fil');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        String dayName = hijriDate.toFormat('DDDD');
        expect(dayName, isNotEmpty);
      });
    });

    group('Bengali Localization', () {
      test('Bengali month names', () {
        HijriCalendar.setLocal('bn');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getLongMonthName(), equals('রমজান'));
        expect(hijriDate.getShortMonthName(), equals('রমজা'));
      });

      test('Bengali numbers in date format', () {
        HijriCalendar.setLocal('bn');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.toFormat('dd/mm/yyyy'), equals('১৫/৯/১৪৪৫'));
      });

      test('Bengali weekday names', () {
        HijriCalendar.setLocal('bn');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        String dayName = hijriDate.toFormat('DDDD');
        expect(dayName, isNotEmpty);
      });
    });

    group('Urdu Localization', () {
      test('Urdu month names', () {
        HijriCalendar.setLocal('ur');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.getLongMonthName(), equals('رمضان'));
        expect(hijriDate.getShortMonthName(), equals('رمضا'));
      });

      test('Urdu numbers in date format', () {
        HijriCalendar.setLocal('ur');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        expect(hijriDate.toFormat('dd/mm/yyyy'), equals('۱۵/۹/۱۴۴۵'));
      });

      test('Urdu weekday names', () {
        HijriCalendar.setLocal('ur');
        hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

        String dayName = hijriDate.toFormat('DDDD');
        expect(dayName, isNotEmpty);
      });
    });

    group('Date Formatting with Different Locales', () {
      test('compare same date in different locales', () {
        Map<String, String> expectedFormats = {
          'en': '15/9/1445',
          'ar': '١٥/٩/١٤٤٥',
          'bn': '১৫/৯/১৪৪৫',
          'ur': '۱۵/۹/۱۴۴۵',
          'id': '15/9/1445',
          'ms': '15/9/1445',
          'fil': '15/9/1445',
          'tr': '15/9/1445',
        };

        for (var entry in expectedFormats.entries) {
          HijriCalendar.setLocal(entry.key);
          hijriDate = HijriCalendar.fromHijri(1445, 9, 15);
          expect(hijriDate.toFormat('dd/mm/yyyy'), equals(entry.value));
        }
      });

      test('full date format in different locales', () {
        // Test that each locale produces a valid formatted date
        List<String> locales = [
          'en',
          'ar',
          'tr',
          'id',
          'ms',
          'fil',
          'bn',
          'ur'
        ];

        for (String locale in locales) {
          HijriCalendar.setLocal(locale);
          hijriDate = HijriCalendar.fromHijri(1445, 9, 15);

          String fullDate = hijriDate.fullDate();
          expect(fullDate, isNotEmpty);
          // Year should be present in some form (could be localized)
          expect(fullDate.length, greaterThan(10));
        }
      });
    });

    group('Utility Functions', () {
      test('get supported locales', () {
        List<String> supported = DigitsConverter.getSupportedLocales();
        expect(supported, contains('ar'));
        expect(supported, contains('bn'));
        expect(supported, contains('ur'));
        expect(supported, contains('id'));
        expect(supported, contains('ms'));
        expect(supported, contains('fil'));
        expect(supported.length, equals(8));
      });

      test('check locale support', () {
        expect(DigitsConverter.isLocaleSupported('ar'), isTrue);
        expect(DigitsConverter.isLocaleSupported('bn'), isTrue);
        expect(DigitsConverter.isLocaleSupported('ur'), isTrue);
        expect(DigitsConverter.isLocaleSupported('xx'), isFalse);
      });
    });

    group('Month Names Consistency', () {
      test('all locales have 12 months', () {
        List<String> locales = [
          'en',
          'ar',
          'tr',
          'id',
          'ms',
          'fil',
          'bn',
          'ur'
        ];

        for (String locale in locales) {
          HijriCalendar.setLocal(locale);
          HijriCalendar cal = HijriCalendar();

          Map<int, String> months = cal.getMonths();
          expect(months.length, equals(12));

          // Check that all month numbers 1-12 are present
          for (int i = 1; i <= 12; i++) {
            expect(months.containsKey(i), isTrue);
            expect(months[i], isNotEmpty);
          }
        }
      });

      test('Ramadan name in different locales', () {
        Map<String, String> ramadanNames = {
          'en': 'Ramadan',
          'ar': 'رمضان',
          'tr': 'RAMAZAN',
          'id': 'Ramadan',
          'ms': 'Ramadan',
          'fil': 'Ramadan',
          'bn': 'রমজান',
          'ur': 'رمضان',
        };

        for (var entry in ramadanNames.entries) {
          HijriCalendar.setLocal(entry.key);
          HijriCalendar cal = HijriCalendar.fromHijri(1445, 9, 1);
          expect(cal.getLongMonthName(), equals(entry.value));
        }
      });
    });
  });
}
