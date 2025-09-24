/// Hijri Calendar Utilities and Constants
/// Provides additional utility functions and constants for Hijri date operations

library hijri_utils;

import 'hijri_date.dart';
import 'religious_event.dart';

/// Islamic Events Helper - integrates with the new religious events system
class IslamicEventsHelper {
  /// Gets Islamic events for a specific date using the new system
  static List<IslamicEvent> getEventsForDate(HijriDate date) {
    final allEvents = IslamicEventsManager.allEvents;
    return allEvents
        .where((event) =>
            event.month == date.hMonth && event.days.contains(date.hDay))
        .toList();
  }

  /// Checks if a date has any Islamic events
  static bool hasEvents(HijriDate date) {
    return getEventsForDate(date).isNotEmpty;
  }

  /// Checks if a date is an Islamic holiday (Eid)
  static bool isIslamicHoliday(HijriDate date) {
    final events = getEventsForDate(date);
    return events.any((event) =>
        event.type == IslamicEventType.eidAlFitr ||
        event.type == IslamicEventType.eidAlAdha);
  }

  /// Gets the next Islamic event from current date
  static IslamicEvent? getNextEvent([HijriDate? fromDate]) {
    fromDate ??= HijriDate.now();
    return IslamicEventsManager.getNextEvent();
  }

  /// Gets all events in a specific month using the new system
  static List<IslamicEvent> getEventsInMonth(int month) {
    return IslamicEventsManager.getEventsInMonth(month);
  }

  /// Gets events by type (Eid, fasting, sacred days, etc.)
  static List<IslamicEvent> getEventsByType(IslamicEventType type) {
    return IslamicEventsManager.getEventsByType(type);
  }

  /// Calculates days until a specific event (simplified version)
  static int calculateDaysUntilEvent(
      HijriDate currentDate, IslamicEvent event) {
    // Find the next occurrence of this event
    final currentYear = currentDate.hYear;

    // Try current year first
    for (int day in event.days) {
      final eventDate = HijriDate.fromHijri(currentYear, event.month, day);
      if (eventDate >= currentDate) {
        // Calculate positive difference (eventDate - currentDate)
        return eventDate.differenceInDays(currentDate);
      }
    }

    // If no occurrence in current year, try next year
    for (int day in event.days) {
      final eventDate = HijriDate.fromHijri(currentYear + 1, event.month, day);
      // Calculate positive difference (eventDate - currentDate)
      return eventDate.differenceInDays(currentDate);
    }

    return 0;
  }

  /// Gets comprehensive day information including events
  static Map<String, dynamic> getDayInformation(HijriDate date) {
    final todayEvents = getEventsForDate(date);
    final nextEvent = getNextEvent(date);

    return {
      'hijriDate': date.fullDate(),
      'todayEvents': todayEvents,
      'hasEvents': todayEvents.isNotEmpty,
      'isHoliday': isIslamicHoliday(date),
      'nextEvent': nextEvent,
      'daysUntilNextEvent':
          nextEvent != null ? calculateDaysUntilEvent(date, nextEvent) : null,
      'eventsInCurrentMonth': getEventsInMonth(date.hMonth),
      'daysLeftInMonth': date.lengthOfMonth - date.hDay,
      'daysLeftInYear': _calculateDaysLeftInYear(date),
    };
  }

  /// Helper method to calculate days left in the current Hijri year
  static int _calculateDaysLeftInYear(HijriDate date) {
    int totalDays = 0;

    // Days left in current month
    totalDays += (date.lengthOfMonth - date.hDay);

    // Days in remaining months
    for (int month = date.hMonth + 1; month <= 12; month++) {
      totalDays += date.getDaysInMonth(date.hYear, month);
    }

    return totalDays;
  }

  /// Gets main events (non-reminder events)
  static List<IslamicEvent> getMainEvents() {
    return IslamicEventsManager.getMainEvents();
  }

  /// Gets reminder events
  static List<IslamicEvent> getReminders() {
    return IslamicEventsManager.getReminders();
  }

  /// Gets events statistics
  static Map<String, int> getEventsStatistics() {
    return IslamicEventsManager.getEventsStatistics();
  }

  /// Gets upcoming events in the next few months
  static List<IslamicEvent> getUpcomingEvents({int monthsAhead = 3}) {
    final currentDate = HijriDate.now();
    final allEvents = IslamicEventsManager.allEvents;
    final upcomingEvents = <IslamicEvent>[];

    for (final event in allEvents) {
      final daysUntil = calculateDaysUntilEvent(currentDate, event);
      // Only include events that are actually upcoming (positive days)
      if (daysUntil > 0 && daysUntil <= monthsAhead * 30) {
        upcomingEvents.add(event);
      }
    }

    // Sort by days until event
    upcomingEvents.sort((a, b) {
      final daysA = calculateDaysUntilEvent(currentDate, a);
      final daysB = calculateDaysUntilEvent(currentDate, b);
      return daysA.compareTo(daysB);
    });

    return upcomingEvents;
  }

  /// Gets all events
  static List<IslamicEvent> getAllEvents() {
    return IslamicEventsManager.allEvents;
  }

  /// Gets upcoming events with accurate calculations and details
  static List<Map<String, dynamic>> getUpcomingEventsWithDetails(
      {int monthsAhead = 6}) {
    final currentDate = HijriDate.now();
    final allEvents = IslamicEventsManager.allEvents;
    final upcomingEvents = <Map<String, dynamic>>[];

    for (final event in allEvents) {
      final daysUntil = calculateDaysUntilEvent(currentDate, event);
      // Only include events that are actually upcoming (positive days)
      if (daysUntil > 0 && daysUntil <= monthsAhead * 30) {
        upcomingEvents.add({
          'event': event,
          'daysUntil': daysUntil,
          'arabicTitle': event.titleArabic,
          'englishTitle': event.titleEnglish,
        });
      }
    }

    // Sort by days until event
    upcomingEvents.sort((a, b) => a['daysUntil'].compareTo(b['daysUntil']));

    return upcomingEvents;
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
  static bool isRecommendedFastingDay(HijriDate date) {
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
  static int daysBetween(HijriDate start, HijriDate end) {
    return start.differenceInDays(end).abs();
  }

  /// Gets all Fridays in a specific Hijri month
  static List<HijriDate> getFridaysInMonth(int year, int month) {
    final daysInMonth = HijriDate().getDaysInMonth(year, month);
    final fridays = <HijriDate>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = HijriDate.fromHijri(year, month, day);
      if (date.wkDay == 5) {
        // Friday
        fridays.add(date);
      }
    }
    return fridays;
  }

  /// Validates if a date range is correct
  static bool isValidDateRange(HijriDate start, HijriDate end) {
    return start <= end;
  }

  /// Generates a list of dates between two dates
  static List<HijriDate> getDateRange(HijriDate start, HijriDate end) {
    if (!isValidDateRange(start, end)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    final dates = <HijriDate>[];
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
  static Map<String, int> calculateDetailedAge(HijriDate birthDate,
      [HijriDate? currentDate]) {
    currentDate ??= HijriDate.now();

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
