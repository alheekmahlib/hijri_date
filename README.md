# 🌙 Hijri Date — Hijri Calendar & Moon Phases Library

[![Pub Version](https://img.shields.io/pub/v/hijri_date)](https://pub.dev/packages/hijri_date)
[![GitHub Stars](https://img.shields.io/github/stars/alheekmahlib/hijri_date)](https://github.com/alheekmahlib/hijri_date/stargazers)
[![Dart SDK](https://img.shields.io/badge/Dart-3.6+-blue.svg)](https://dart.dev)

Professional Dart/Flutter library for the Islamic (Hijri, Umm al-Qura) calendar: accurate Hijri↔Gregorian conversion, moon phases, Islamic events with authentic hadiths, multi-language support with localized numerals, and robust calendar utilities. Each section provides concise, non-duplicated examples.

## Contents

<p>
  <a href="#features"><img alt="Features" src="https://img.shields.io/badge/-Features-0b72b9?style=for-the-badge" /></a>
  <a href="#installation"><img alt="Installation" src="https://img.shields.io/badge/-Installation-0b72b9?style=for-the-badge" /></a>
  <a href="#quick-start"><img alt="Quick Start" src="https://img.shields.io/badge/-Quick%20Start-0b72b9?style=for-the-badge" /></a>
  <a href="#core-concepts"><img alt="Core Concepts" src="https://img.shields.io/badge/-Core%20Concepts-0b72b9?style=for-the-badge" /></a>
  <a href="#formatting"><img alt="Formatting" src="https://img.shields.io/badge/-Formatting-0b72b9?style=for-the-badge" /></a>
  <a href="#date-operations"><img alt="Date Operations" src="https://img.shields.io/badge/-Date%20Operations-0b72b9?style=for-the-badge" /></a>
  <a href="#calendar-utilities"><img alt="Calendar Utilities" src="https://img.shields.io/badge/-Calendar%20Utilities-0b72b9?style=for-the-badge" /></a>
  <a href="#moon-phases"><img alt="Moon Phases" src="https://img.shields.io/badge/-Moon%20Phases-0b72b9?style=for-the-badge" /></a>
  <a href="#islamic-events"><img alt="Islamic Events" src="https://img.shields.io/badge/-Islamic%20Events-0b72b9?style=for-the-badge" /></a>
  <a href="#localization--numerals"><img alt="Localization & Numerals" src="https://img.shields.io/badge/-Localization%20%26%20Numerals-0b72b9?style=for-the-badge" /></a>
  <a href="#compact-example"><img alt="Compact Example" src="https://img.shields.io/badge/-Compact%20Example-0b72b9?style=for-the-badge" /></a>
</p>

## Features

- Accurate Hijri↔Gregorian conversion (Umm al-Qura)
- Strong validation with clear error messages
- Flexible formatting with tokens and locale-aware numerals
- Full date math: add/subtract days, months, years (overflow-safe)
- Comparisons (<, <=, >, >=, ==) and difference in days
- Utilities: days in month/year, week number, weekend detection
- Moon phases, illumination, hilal visibility, and statistics
- Built-in Islamic events with authentic hadiths and stats
- Multi-language support: ar, en, tr, id, ms, fil, bn, ur

## Installation

Add to your pubspec.yaml:

```yaml
dependencies:
  hijri_date: ^1.0.0
```

Single entry import:

```dart
import 'package:hijri_date/hijri.dart';
```

## Quick Start

```dart
import 'package:hijri_date/hijri.dart';

void main() {
  // Current Hijri date
  final today = HijriDate.now();
  print(today.fullDate()); // Wednesday, Rajab 15, 1445 h

  // From Gregorian date
  final fromGregorian = HijriDate.fromDate(DateTime(2024, 3, 15));
  print(fromGregorian.fullDate());

  // Locale (affects names and numerals)
  HijriDate.setLocal('ar');
  print(today.fullDate()); // الأربعاء، رجب ١٥، ١٤٤٥ هـ

  // Moon phase
  final moon = today.getMoonPhase();
  print('${today.getMoonPhaseName()} • ${(moon.illumination * 100).toStringAsFixed(1)}%');

  // Events
  final todays = IslamicEventsManager.getTodaysEvents();
  final next = IslamicEventsManager.getNextEvent();
  print("Today's events: ${todays.length}");
  print('Next: ${next?.getTitle('en')} in ${next?.daysUntilEvent()} day(s)');
}
```

## Core Concepts

```dart
// Create dates
final d1 = HijriDate.now();
final d2 = HijriDate.fromDate(DateTime(2024, 3, 15));
final d3 = HijriDate.fromHijri(1445, 9, 15); // validates month/day

// Convert
final g = d3.hijriToGregorian(d3.hYear, d3.hMonth, d3.hDay); // DateTime
final h = HijriDate.fromDate(DateTime.now());                 // HijriDate

// Validation
try {
  HijriDate.fromHijri(1445, 13, 1);
} catch (e) {
  print(e); // Invalid Hijri date: 1445/13/1
}
```

## Formatting

```dart
final date = HijriDate.fromHijri(1445, 9, 15);
print(date.fullDate());                    // Wednesday, Ramadan 15, 1445 h
print(date.toString());                    // 15/09/1445H (or yyyy/mm/dd in ar)
print(date.toFormat('DDDD, MMMM dd, yyyy')); // Wednesday, Ramadan 15, 1445
print(date.toFormat('dd/mm/yyyy'));         // 15/09/1445

// Tokens:
// DDDD: full weekday | DD: short weekday
// MMMM: full month   | MM: short month
// yyyy: full year    | yy: 2-digit year
// dd/mm: day/month digits localized to current language
```

## Date Operations

```dart
final t = HijriDate.fromHijri(1445, 9, 15);
final after30 = t.addDays(30);
final minus2m = t.subtractMonths(2);
final nextYear = t.addYears(1);

// Comparisons and difference
final a = HijriDate.fromHijri(1445, 9, 15);
final b = HijriDate.fromHijri(1445, 10, 1);
print(a < b);                      // true
print(a.differenceInDays(b));      // -16
print(t.ageInYears(HijriDate.now()));
```

## Calendar Utilities

```dart
final today = HijriDate.now();
print(today.lengthOfMonth);
print(today.lengthOfYear(year: today.hYear));
print(today.dayOfYear);
print(today.weekOfYear);
print(today.isWeekend);

print(today.firstDayOfMonth.fullDate());
print(today.lastDayOfMonth.fullDate());

final monthDays = today.getMonthDays(9, 1445); // map: day -> weekday name
final months = today.getMonths();               // localized month names

final json = today.toJson();
final copy = HijriDate.fromJson(json);
print(copy.isoFormat);                          // yyyy-mm-dd
```

## Moon Phases

```dart
final h = HijriDate.fromHijri(1445, 9, 15);
final m = h.getMoonPhase();
print(h.getMoonPhaseName());
print((m.illumination * 100).toStringAsFixed(1));
print('Is full? ${h.isFullMoon()}  Is new? ${h.isNewMoon()}');
print('Days to next full: ${h.daysUntilNextFullMoon()}');

final fullMoons = HijriDate.getFullMoonDatesInYear(1445);
final newMoons  = HijriDate.getNewMoonDatesInYear(1445);

final stats = HijriDate.getMoonPhaseStatisticsForMonth(1445, 9); // {phase -> days}
```

## Islamic Events

```dart
// Available via the same import: hijri.dart
final todays = IslamicEventsManager.getTodaysEvents();
final next = IslamicEventsManager.getNextEvent();

if (next != null) {
  print('Next: ${next.getTitle('en')} in ${next.daysUntilEvent()} day(s)');
}

final ramadanEvents = IslamicEventsManager.getEventsInMonth(9);
final stats = IslamicEventsManager.getEventsStatistics(); // totalEvents, mainEvents, reminders

final hadiths = IslamicEventsManager.getHadithsForEventType(IslamicEventType.ramadan);
```

Examples include: Islamic New Year, Tasoo'a/Ashura, Beginning of Ramadan, Laylat al-Qadr (reminder), Eid al-Fitr, Six of Shawwal (reminder), Ten Days of Dhul-Hijjah, Day of Arafah, Eid al-Adha.

## Localization & Numerals

```dart
final date = HijriDate.fromHijri(1445, 1, 15);

for (final lang in ['ar','en','tr','id','ms','fil','bn','ur']) {
  HijriDate.setLocal(lang);
  print('$lang: ${date.toFormat('dd/mm/yyyy')} - ${date.getLongMonthName()}');
}

// Manual digit conversion utilities
final nAr = DigitsConverter.convertNumberToLocale(1445, 'ar'); // ١٤٤٥
final nUr = DigitsConverter.convertNumberToLocale(1445, 'ur'); // ۱۴۴۵
```

## Compact Example

```dart
import 'package:hijri_date/hijri.dart';

void demo() {
  HijriDate.setLocal('en');
  final today = HijriDate.now();

  if (today.hMonth == 9) {
    final moon = today.getMoonPhase();
    print('Ramadan • ${today.getMoonPhaseName(language: 'en')} • ${(moon.illumination * 100).toStringAsFixed(1)}%');
  }

  if (today.hMonth == 12 && today.hDay >= 8 && today.hDay <= 13) {
    print('Hajj season');
  }

  for (final e in IslamicEventsManager.getTodaysEvents()) {
    print('Today: ${e.getTitle('en')}');
  }
}
```
