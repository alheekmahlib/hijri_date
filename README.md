# 📅 Hijri Calendar Converter

[![Pub Version](https://img.shields.io/pub/v/hijri)](https://pub.dev/packages/hijri)
[![License](https://img.shields.io/github/license/alheekmahlib/hijri_date)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/alheekmahlib/hijri_date)](https://github.com/alheekmahlib/hijri_date/stargazers)

A comprehensive and accurate Hijri (Islamic) calendar library for Dart and Flutter with support for date conversion, formatting, localization, and advanced features.

## ✨ Features

- ✅ Accurate Hijri to Gregorian conversion and vice versa
- ✅ Multi-language support (Arabic, English, Turkish)
- ✅ Flexible date formatting with multiple options
- ✅ Date validation with clear error messages
- ✅ Date arithmetic operations (add/subtract days, months, years)
- ✅ Date comparison operators (`<`, `<=`, `>`, `>=`, `==`)
- ✅ Age calculation (simple and detailed)
- ✅ Null safety support
- ✅ Comprehensive testing

## 📦 Installation

```yaml
dependencies:
  hijri: ^3.0.0
```

## 🚀 Quick Start

```dart
import 'package:hijri/hijri_calendar.dart';

void main() {
  // Current Hijri date
  var today = HijriCalendar.now();
  print('Today: ${today.fullDate()}'); // Wednesday, Rajab 15, 1445 h
  
  // From Gregorian date
  var hijriDate = HijriCalendar.fromDate(DateTime(2024, 3, 15));
  print('Hijri: ${hijriDate.fullDate()}');
  
  // From custom Hijri date
  var customDate = HijriCalendar.fromHijri(1445, 9, 15);
  print('Custom: ${customDate.fullDate()}');
}
```

## 📖 Usage Examples

### Creating Dates

```dart
// Current Hijri date
var now = HijriCalendar.now();
print(now.hYear);  // 1445
print(now.hMonth); // 9  
print(now.hDay);   // 15
print(now.getDayName()); // Wednesday
print(now.lengthOfMonth); // 30 days

// From Gregorian date
var fromGregorian = HijriCalendar.fromDate(DateTime(2024, 3, 15));
print(fromGregorian.toString()); // 06/09/1445H

// From custom Hijri date
var customHijri = HijriCalendar.fromHijri(1445, 9, 15);
print(customHijri.hYear);  // 1445
print(customHijri.hMonth); // 9
print(customHijri.hDay);   // 15
print(customHijri.getLongMonthName());  // Ramadan
print(customHijri.getShortMonthName()); // Ram
```

### Localization

```dart
// Change locale
HijriCalendar.setLocal('ar'); // Arabic
var arabicDate = HijriCalendar.now();
print(arabicDate.fullDate()); // الأربعاء، رجب ١٥، ١٤٤٥ هـ

HijriCalendar.setLocal('en'); // English (default)
var englishDate = HijriCalendar.now();
print(englishDate.fullDate()); // Wednesday, Rajab 15, 1445 h

// Add new locale
HijriCalendar.addLocale('id', {
  'long': {1: 'Muharram', 2: 'Safar', /* ... */},
  'short': {1: 'Muh', 2: 'Saf', /* ... */}, 
  'days': {1: 'Senin', 2: 'Selasa', /* ... */},
  'short_days': {1: 'Sen', 2: 'Sel', /* ... */}
});
HijriCalendar.setLocal('id');
```

### Date Validation

```dart
// Manual validation
var date = HijriCalendar();
date.hYear = 1445;
date.hMonth = 11;
date.hDay = 30;
print(date.isValid()); // false -> This month has only 29 days

// Automatic validation with fromHijri constructor
try {
  var invalidDate = HijriCalendar.fromHijri(1445, 1, 30); // Invalid day
} catch (e) {
  print(e); // Error: Day 30 is invalid for month 1 of year 1445
}

try {
  var invalidMonth = HijriCalendar.fromHijri(1445, 13, 1); // Invalid month
} catch (e) {
  print(e); // Error: Invalid Hijri date: 1445/13/1
}
```

### Date Conversion

```dart
// Hijri to Gregorian
var hijriDate = HijriCalendar.fromHijri(1445, 9, 15);
var gregorianDate = hijriDate.hijriToGregorian(1445, 9, 15);
print(gregorianDate); // 2024-03-25 00:00:00.000

// Gregorian to Hijri  
var today = DateTime.now();
var hijriToday = HijriCalendar.fromDate(today);
print(hijriToday.fullDate());
```

### Date Formatting

```dart
var date = HijriCalendar.fromHijri(1445, 9, 15);

// Built-in formats
print(date.fullDate());    // Wednesday, Ramadan 15, 1445 h
print(date.toString());    // 15/09/1445H

// Custom formatting
print(date.toFormat("DDDD, MMMM dd, yyyy")); // Wednesday, Ramadan 15, 1445
print(date.toFormat("dd/mm/yyyy"));          // 15/09/1445
print(date.toFormat("mm dd yy"));            // 09 15 45
print(date.toFormat("MMMM yyyy"));           // Ramadan 1445
print(date.toFormat("MM dd"));               // Ram 15

// Format tokens:
// DDDD = Full day name (Wednesday)
// DD   = Short day name (Wed)  
// MMMM = Full month name (Ramadan)
// MM   = Short month name (Ram)
// yyyy = Full year (1445)
// yy   = Short year (45)
// dd   = Day with leading zero (05)
// d    = Day without leading zero (5)
// mm   = Month number with leading zero (09)
// m    = Month number without leading zero (9)
```

### Date Comparison

```dart
var date1 = HijriCalendar.fromHijri(1445, 9, 15);
var date2 = HijriCalendar.fromHijri(1445, 10, 1);

// Comparison methods
print(date1.isBefore(1445, 10, 1));      // true
print(date1.isAfter(1445, 8, 29));       // true  
print(date1.isAtSameMomentAs(1445, 9, 15)); // true

// You can also compare with other HijriCalendar objects
if (date1.isBefore(date2.hYear, date2.hMonth, date2.hDay)) {
  print('Date1 is before Date2');
}
```

### Utility Methods

```dart
var date = HijriCalendar.now();

// Get days in month
print(date.getDaysInMonth(1445, 9)); // 30

// Get days in year  
print(date.lengthOfYear(year: 1445)); // 354 or 355

// Get month calendar (day number -> day name mapping)
var monthCalendar = date.getMonthDays(9, 1445);
print(monthCalendar[1]);  // Wednesday (first day of month)
print(monthCalendar[15]); // Thursday (15th day)

// Get all month names
var allMonths = date.getMonths();
print(allMonths[9]); // Ramadan
```

## 🌍 Supported Languages

| Language | Code | Month Names | Day Names | Numbers |
|----------|------|-------------|-----------|---------|
| English  | `en` | ✅ | ✅ | Western |
| Arabic   | `ar` | ✅ | ✅ | Eastern Arabic |
| Turkish  | `tr` | ✅ | ✅ | Western |

## 🧪 Testing

Run the test suite:

```bash
dart test
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔄 Changelog

### v3.0.0
- ✨ Null safety support
- 🔧 Stricter types
- 🔧 Removed `new` keyword requirements
- 🔧 Enhanced validation with clear error messages

### v2.0.3
- ✨ Added new methods to return month names and day names

### v2.0.2
- 📚 Updated README.md

### v2.0.0
- 🔧 Changed `ummAlquarCalendar` to `HijriCalendar`
- 🐛 Fixed various issues

## 📞 Support

If you have any questions or issues:
- [GitHub Issues](https://github.com/alheekmahlib/hijri_date/issues)
- [GitHub Discussions](https://github.com/alheekmahlib/hijri_date/discussions)

---

Made with ❤️ for the Islamic community

