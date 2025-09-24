/// Hijri Calendar Utilities and Constants
/// Provides additional utility functions and constants for Hijri date operations

library hijri_utils;

import 'hijri_calendar.dart';

/// Important Islamic dates and their significance
class IslamicEvents {
  static const Map<String, Map<String, dynamic>> events = {
    // Muharram events
    '1/1': {
      'name': 'رأس السنة الهجرية',
      'nameEn': 'Islamic New Year',
      'type': 'religious'
    },
    '1/10': {'name': 'عاشوراء', 'nameEn': 'Day of Ashura', 'type': 'religious'},

    // Rabi' Al-Awwal events
    '3/12': {
      'name': 'المولد النبوي الشريف',
      'nameEn': 'Prophet Muhammad Birthday',
      'type': 'religious'
    },

    // Rajab events
    '7/27': {
      'name': 'ليلة الإسراء والمعراج',
      'nameEn': 'Isra and Mi\'raj',
      'type': 'religious'
    },

    // Sha'aban events
    '8/15': {
      'name': 'ليلة البراءة',
      'nameEn': 'Laylat al-Bara\'at',
      'type': 'religious'
    },

    // Ramadan events
    '9/27': {
      'name': 'ليلة القدر',
      'nameEn': 'Laylat al-Qadr',
      'type': 'religious'
    },

    // Shawwal events
    '10/1': {'name': 'عيد الفطر', 'nameEn': 'Eid al-Fitr', 'type': 'holiday'},

    // Dhu Al-Hijjah events
    '12/9': {
      'name': 'يوم عرفة',
      'nameEn': 'Day of Arafah',
      'type': 'religious'
    },
    '12/10': {'name': 'عيد الأضحى', 'nameEn': 'Eid al-Adha', 'type': 'holiday'},
  };

  /// Gets the Islamic event for a specific date
  static Map<String, dynamic>? getEventForDate(HijriCalendar date) {
    final key = '${date.hMonth}/${date.hDay}';
    return events[key];
  }

  /// Checks if a date is an Islamic holiday
  static bool isIslamicHoliday(HijriCalendar date) {
    final event = getEventForDate(date);
    return event?['type'] == 'holiday';
  }

  /// Gets all events in a specific month
  static List<Map<String, dynamic>> getEventsInMonth(int month) {
    return events.entries
        .where((entry) => entry.key.startsWith('$month/'))
        .map((entry) => {
              'day': int.parse(entry.key.split('/')[1]),
              ...entry.value,
            })
        .toList();
  }
}

/// Prayer times calculation helper
class PrayerTimeHelper {
  /// Gets the recommended fasting days in a month
  static List<int> getRecommendedFastingDays(int month) {
    switch (month) {
      case 1: // Muharram
        return [9, 10, 11]; // 9th, Ashura, and 11th
      case 8: // Sha'aban
        return [13, 14, 15]; // White days
      case 11: // Dhu Al-Qi'dah
        return [13, 14, 15]; // White days
      default:
        return [13, 14, 15]; // White days (every month)
    }
  }

  /// Checks if a date falls on a recommended fasting day
  static bool isRecommendedFastingDay(HijriCalendar date) {
    final recommendedDays = getRecommendedFastingDays(date.hMonth);
    return recommendedDays.contains(date.hDay);
  }
}

/// Hijri date validation and utilities
class HijriUtils {
  /// Converts Hijri year to approximate Gregorian year
  static int hijriToGregorianYear(int hijriYear) {
    // Rough conversion: Hijri year starts approximately 621-622 CE
    return ((hijriYear * 354.37) / 365.25 + 621.5).round();
  }

  /// Converts Gregorian year to approximate Hijri year
  static int gregorianToHijriYear(int gregorianYear) {
    // Rough conversion
    return ((gregorianYear - 621.5) * 365.25 / 354.37).round();
  }

  /// Gets the season based on Hijri month
  static String getSeason(int month, [String language = 'en']) {
    final seasons = {
      'en': {
        'spring': [7, 8, 9], // Rajab, Sha'aban, Ramadan
        'summer': [10, 11, 12], // Shawwal, Dhu Al-Qi'dah, Dhu Al-Hijjah
        'autumn': [1, 2, 3], // Muharram, Safar, Rabi' Al-Awwal
        'winter': [4, 5, 6], // Rabi' Al-Thani, Jumada Al-Awwal, Jumada Al-Thani
      },
      'ar': {
        'spring': [7, 8, 9],
        'summer': [10, 11, 12],
        'autumn': [1, 2, 3],
        'winter': [4, 5, 6],
      }
    };

    final seasonNames = {
      'en': {
        'spring': 'Spring',
        'summer': 'Summer',
        'autumn': 'Autumn',
        'winter': 'Winter'
      },
      'ar': {
        'spring': 'الربيع',
        'summer': 'الصيف',
        'autumn': 'الخريف',
        'winter': 'الشتاء'
      },
    };

    for (final entry in seasons[language]!.entries) {
      if (entry.value.contains(month)) {
        return seasonNames[language]![entry.key]!;
      }
    }
    return 'Unknown';
  }

  /// Calculates the number of days between two Hijri dates
  static int daysBetween(HijriCalendar start, HijriCalendar end) {
    return start.differenceInDays(end).abs();
  }

  /// Gets all Fridays in a specific Hijri month
  static List<HijriCalendar> getFridaysInMonth(int year, int month) {
    final daysInMonth = HijriCalendar().getDaysInMonth(year, month);
    final fridays = <HijriCalendar>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = HijriCalendar.fromHijri(year, month, day);
      if (date.wkDay == 5) {
        // Friday
        fridays.add(date);
      }
    }
    return fridays;
  }

  /// Validates if a date range is correct
  static bool isValidDateRange(HijriCalendar start, HijriCalendar end) {
    return start <= end;
  }

  /// Generates a list of dates between two dates
  static List<HijriCalendar> getDateRange(
      HijriCalendar start, HijriCalendar end) {
    if (!isValidDateRange(start, end)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    final dates = <HijriCalendar>[];
    var current = start.copy();

    while (current <= end) {
      dates.add(current.copy());
      current = current.addDays(1);
    }

    return dates;
  }
}

/// Age calculation utilities
class AgeCalculator {
  /// Calculates detailed age (years, months, days)
  static Map<String, int> calculateDetailedAge(HijriCalendar birthDate,
      [HijriCalendar? currentDate]) {
    currentDate ??= HijriCalendar.now();

    int years = currentDate.hYear - birthDate.hYear;
    int months = currentDate.hMonth - birthDate.hMonth;
    int days = currentDate.hDay - birthDate.hDay;

    if (days < 0) {
      months--;
      final daysInPrevMonth = currentDate.subtractMonths(1).getDaysInMonth(
          currentDate.hYear,
          currentDate.hMonth - 1 <= 0 ? 12 : currentDate.hMonth - 1);
      days += daysInPrevMonth;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  /// Gets age category based on years
  static String getAgeCategory(int ageInYears, [String language = 'en']) {
    final categories = {
      'en': {
        'infant': [0, 2],
        'child': [2, 12],
        'teenager': [12, 18],
        'adult': [18, 60],
        'senior': [60, 150],
      },
      'ar': {
        'infant': [0, 2],
        'child': [2, 12],
        'teenager': [12, 18],
        'adult': [18, 60],
        'senior': [60, 150],
      }
    };

    final categoryNames = {
      'en': {
        'infant': 'Infant',
        'child': 'Child',
        'teenager': 'Teenager',
        'adult': 'Adult',
        'senior': 'Senior',
      },
      'ar': {
        'infant': 'رضيع',
        'child': 'طفل',
        'teenager': 'مراهق',
        'adult': 'بالغ',
        'senior': 'كبير السن',
      }
    };

    for (final entry in categories[language]!.entries) {
      if (ageInYears >= entry.value[0] && ageInYears < entry.value[1]) {
        return categoryNames[language]![entry.key]!;
      }
    }
    return 'Unknown';
  }
}
