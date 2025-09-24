library hijri_date;

import 'digits_converter.dart';
import 'hijri_array.dart';
import 'moon_phases.dart';
import 'religious_event.dart';

class HijriDate {
  static String language = 'en';
  late int lengthOfMonth;
  int hDay = 1;
  late int hMonth;
  late int hYear;
  int? wkDay;
  late String longMonthName;
  late String shortMonthName;
  late String dayWeName;
  Map<int, int>? adjustments;

  static Map<String, Map<String, Map<int, String>>> _local = {
    'en': {
      'long': monthNames,
      'short': monthShortNames,
      'days': wdNames,
      'short_days': shortWdNames
    },
    'ar': {
      'long': arMonthNames,
      'short': arMonthShortNames,
      'days': arWkNames,
      'short_days': arShortWdNames
    },
    'tr': {
      'long': trMonthNames,
      'short': trMonthShortNames,
      'days': trWkNames,
      'short_days': trShortWdNames
    },
    'id': {
      'long': idMonthNames,
      'short': idMonthShortNames,
      'days': idWkNames,
      'short_days': idShortWdNames
    },
    'ms': {
      'long': msMonthNames,
      'short': msMonthShortNames,
      'days': msWkNames,
      'short_days': msShortWdNames
    },
    'fil': {
      'long': filMonthNames,
      'short': filMonthShortNames,
      'days': filWkNames,
      'short_days': filShortWdNames
    },
    'bn': {
      'long': bnMonthNames,
      'short': bnMonthShortNames,
      'days': bnWkNames,
      'short_days': bnShortWdNames
    },
    'ur': {
      'long': urMonthNames,
      'short': urMonthShortNames,
      'days': urWkNames,
      'short_days': urShortWdNames
    },
  };

  /// Sets the language for localization
  /// Returns a new HijriCalendar instance with the specified locale
  factory HijriDate.setLocal(String locale) {
    if (!_local.containsKey(locale)) {
      throw ArgumentError(
          'Unsupported locale: $locale. Supported locales: ${_local.keys.join(', ')}');
    }
    language = locale;
    return HijriDate();
  }

  HijriDate();

  HijriDate.fromDate(DateTime date) {
    gregorianToHijri(date.year, date.month, date.day);
  }

  HijriDate.fromHijri(int year, int month, int day) {
    if (!validateHijri(year, month, day)) {
      throw ArgumentError('Invalid Hijri date: $year/$month/$day');
    }

    // Validate that the day is within the month's range
    int daysInMonth = getDaysInMonth(year, month);
    if (day > daysInMonth) {
      throw ArgumentError(
          'Day $day is invalid for month $month of year $year. This month has only $daysInMonth days.');
    }

    hYear = year;
    hMonth = month;
    hDay = day;
    lengthOfMonth = daysInMonth;

    // Calculate week day
    DateTime gregorianDate = hijriToGregorian(year, month, day);
    wkDay = gregorianDate.weekday == 7 ? 7 : gregorianDate.weekday;

    // Set month and day names
    longMonthName = _local[language]!['long']![month]!;
    shortMonthName = _local[language]!['short']![month]!;
    dayWeName = _local[language]!['days']![wkDay]!;
  }

  HijriDate.now() {
    this._now();
  }

  HijriDate.addMonth(int year, int month) {
    hYear = month % 12 == 0 ? year - 1 : year;
    hMonth = month % 12 == 0 ? 12 : month % 12;
    hDay = 1;
  }

  HijriDate.addLocale(String locale, Map<String, Map<int, String>> names) {
    _local[locale] = names;
  }

  String _now() {
    DateTime today = DateTime.now();
    return gregorianToHijri(today.year, today.month, today.day);
  }

  int getDaysInMonth(int year, int month) {
    int i = _getNewMoonMJDNIndex(year, month);
    return _ummalquraDataIndex(i) - _ummalquraDataIndex(i - 1);
  }

  int _gMod(int n, int m) {
    // generalized modulo function (n mod m) also valid for negative values of n
    return ((n % m) + m) % m;
  }

  int _getNewMoonMJDNIndex(int hy, int hm) {
    int cYears = hy - 1, totalMonths = (cYears * 12) + 1 + (hm - 1);
    return totalMonths - 16260;
  }

  int lengthOfYear({int? year = 0}) {
    int total = 0;
    if (year == 0) year = this.hYear;
    for (int m = 0; m <= 11; m++) {
      total += getDaysInMonth(year!, m);
    }
    return total;
  }

  DateTime hijriToGregorian(year, month, day) {
    int iy = year;
    int im = month;
    int id = day;
    int ii = iy - 1;
    int iln = (ii * 12) + 1 + (im - 1);
    int i = iln - 16260;
    int mcjdn = id + _ummalquraDataIndex(i - 1) - 1;
    int cjdn = mcjdn + 2400000;
    return julianToGregorian(cjdn);
  }

  DateTime julianToGregorian(julianDate) {
    //source from: http://keith-wood.name/calendars.html
    int z = (julianDate + 0.5).floor();
    int a = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + a - (a / 4).floor();
    int b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();
    int day = b - d - (e * 30.6001).floor();
    //var wd = _gMod(julianDate + 1, 7) + 1;
    int month = e - (e > 13.5 ? 13 : 1);
    int year = c - (month > 2.5 ? 4716 : 4715);
    if (year <= 0) {
      year--;
    } // No year zero
    return DateTime(year, (month), day);
  }

  String gregorianToHijri(int pYear, int pMonth, int pDay) {
    //This code the modified version of R.H. van Gent Code, it can be found at http://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    // read calendar data

    int day = (pDay);
    int month =
        (pMonth); // -1; // Here we enter the Index of the month (which starts with Zero)
    int year = (pYear);

    int m = month;
    int y = year;

    // append January and February to the previous year (i.e. regard March as
    // the first month of the year in order to simplify leapday corrections)

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    // determine offset between Julian and Gregorian calendar

    int a = (y / 100).floor();
    int jgc = a - (a / 4.0).floor() - 2;

    // compute Chronological Julian Day Number (CJDN)

    int cjdn = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day -
        jgc -
        1524;

    a = ((cjdn - 1867216.25) / 36524.25).floor();
    jgc = a - (a / 4.0).floor() + 1;
    int b = cjdn + jgc + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    month = ((b - d) / 30.6001).floor();
    day = (b - d) - (30.6001 * month).floor();

    if (month > 13) {
      c += 1;
      month -= 12;
    }

    month -= 1;
    year = c - 4716;

    // compute Modified Chronological Julian Day Number (MCJDN)

    int mcjdn = cjdn - 2400000;

    // the MCJDN's of the start of the lunations in the Umm al-Qura calendar are stored in 'islamcalendar_dat.js'
    int i;
    for (i = 0; i < ummAlquraDateArray.length; i++) {
      if (_ummalquraDataIndex(i) > mcjdn) break;
    }

    // compute and output the Umm al-Qura calendar date

    int iln = i + 16260;
    int ii = ((iln - 1) / 12).floor();
    int iy = ii + 1;
    int im = iln - 12 * ii;
    int id = mcjdn - _ummalquraDataIndex(i - 1) + 1;
    int ml = _ummalquraDataIndex(i) - _ummalquraDataIndex(i - 1);
    lengthOfMonth = ml;
    int wd = _gMod(cjdn + 1, 7);

    wkDay = wd == 0 ? 7 : wd;
    return hDate(iy, im, id);
  }

  String hDate(int year, int month, int day) {
    this.hYear = year;
    this.hMonth = month;
    this.longMonthName = _local[language]!['long']![month]!;
    this.dayWeName = _local[language]!['days']![wkDay]!;
    this.shortMonthName = _local[language]!['short']![month]!;
    this.hDay = day;
    return format(this.hYear, this.hMonth, this.hDay, "dd/mm/yyyy");
  }

  String toFormat(String format) {
    return this.format(this.hYear, this.hMonth, this.hDay, format);
  }

  String format(year, month, day, format) {
    String newFormat = format;

    // Convert numbers according to current language
    // تحويل الأرقام حسب اللغة الحالية
    String dayString = DigitsConverter.convertNumberToLocale(day, language);
    String monthString = DigitsConverter.convertNumberToLocale(month, language);
    String yearString = DigitsConverter.convertNumberToLocale(year, language);

    if (newFormat.contains("dd")) {
      newFormat = newFormat.replaceFirst("dd", dayString);
    } else {
      if (newFormat.contains("d")) {
        newFormat = newFormat.replaceFirst("d", day.toString());
      }
    }

    //=========== Day Name =============//
    // Friday
    if (newFormat.contains("DDDD")) {
      newFormat = newFormat.replaceFirst(
          "DDDD", "${_local[language]!['days']![wkDay ?? weekDay()]}");

      // Fri
    } else if (newFormat.contains("DD")) {
      newFormat = newFormat.replaceFirst(
          "DD", "${_local[language]!['short_days']![wkDay ?? weekDay()]}");
    }

    //============== Month ========================//
    // 1
    if (newFormat.contains("mm")) {
      newFormat = newFormat.replaceFirst("mm", monthString);
    } else {
      newFormat = newFormat.replaceFirst("m", monthString);
    }

    // Muharram
    if (newFormat.contains("MMMM")) {
      newFormat =
          newFormat.replaceFirst("MMMM", _local[language]!['long']![month]!);
    } else {
      if (newFormat.contains("MM")) {
        newFormat =
            newFormat.replaceFirst("MM", _local[language]!['short']![month]!);
      }
    }

    //================= Year ========================//
    if (newFormat.contains("yyyy")) {
      newFormat = newFormat.replaceFirst("yyyy", yearString);
    } else {
      newFormat = newFormat.replaceFirst("yy", yearString.substring(2, 4));
    }
    return newFormat;
  }

  bool isBefore(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch <
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  bool isAfter(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch >
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  bool isAtSameMomentAs(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch ==
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  void setAdjustments(Map<int, int> adj) {
    adjustments = adj;
  }

  /// Gets the Umm al-Qura data for a specific index with optional adjustments
  int _ummalquraDataIndex(int index) {
    if (index < 0 || index >= ummAlquraDateArray.length) {
      throw RangeError(
          "Date index out of range. Valid dates are between 1356 AH (14 March 1937 CE) to 1500 AH (16 November 2077 CE)");
    }

    // Apply adjustment if available
    final adjustmentKey = index + 16260;
    if (adjustments?.containsKey(adjustmentKey) == true) {
      return adjustments![adjustmentKey]!;
    }

    return ummAlquraDateArray[index];
  }

  int weekDay() {
    DateTime wkDay = hijriToGregorian(hYear, hMonth, hDay);
    return wkDay.weekday;
  }

  @override
  String toString() {
    String dateFormat = "dd/mm/yyyy";
    if (language == "ar") dateFormat = "yyyy/mm/dd";

    return format(hYear, hMonth, hDay, dateFormat);
  }

  List<int?> toList() => [hYear, hMonth, hDay];

  String fullDate() {
    return format(hYear, hMonth, hDay, "DDDD, MMMM dd, yyyy");
  }

  bool isValid() {
    if (validateHijri(this.hYear, this.hMonth, this.hDay)) {
      if (this.hDay <= getDaysInMonth(this.hYear, this.hMonth)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Validates a Hijri date with comprehensive checks
  bool validateHijri(int year, int month, int day) {
    // Check basic ranges
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 30) return false;

    // Check year range based on available data
    if (year < 1356 || year > 1500) return false;

    // Check if day is valid for the specific month and year
    try {
      int daysInMonth = getDaysInMonth(year, month);
      return day <= daysInMonth;
    } catch (e) {
      return false;
    }
  }

  String getLongMonthName() {
    return _local[language]!['long']![hMonth]!;
  }

  String getShortMonthName() {
    return _local[language]!['short']![hMonth]!;
  }

  String getDayName() {
    return _local[language]!['days']![wkDay]!;
  }

  // to get all month names in long format
  Map<int, String> getMonths() {
    return _local[language]!['long']!;
  }

  // to get specific month days on map of date and day name
  Map<int, String> getMonthDays(int month, int year) {
    Map<int, String> calender = {};
    int d = hijriToGregorian(year, month, 1).weekday;
    int daysInMonth = getDaysInMonth(year, month);
    for (int i = 1; i <= daysInMonth; i++) {
      calender.putIfAbsent(i, () => _local[language]!['days']![d]!);
      d = d < 7 ? d + 1 : 1;
    }
    return calender;
  }

  /// Gets the current Hijri date as a formatted string
  static String get currentHijriDate {
    final today = HijriDate.now();
    return today.fullDate();
  }

  /// Checks if current year is a leap year (355 days vs 354 days)
  bool get isLeapYear => lengthOfYear() == 355;

  /// Gets the number of days passed since the beginning of the current Hijri year
  int get dayOfYear {
    int days = 0;
    for (int i = 1; i < hMonth; i++) {
      days += getDaysInMonth(hYear, i);
    }
    return days + hDay;
  }

  /// Gets the week number in the current year
  int get weekOfYear {
    return ((dayOfYear - 1) / 7).floor() + 1;
  }

  /// Checks if the date falls on a weekend (Friday or Saturday in Islamic calendar)
  bool get isWeekend => wkDay == 5 || wkDay == 6; // Friday or Saturday

  /// Gets the first day of the current month
  HijriDate get firstDayOfMonth {
    return HijriDate.fromHijri(hYear, hMonth, 1);
  }

  /// Gets the last day of the current month
  HijriDate get lastDayOfMonth {
    final daysInMonth = getDaysInMonth(hYear, hMonth);
    return HijriDate.fromHijri(hYear, hMonth, daysInMonth);
  }

  /// Adds specified number of days to the current date
  HijriDate addDays(int days) {
    final gregorianDate = hijriToGregorian(hYear, hMonth, hDay);
    final newGregorianDate = gregorianDate.add(Duration(days: days));
    return HijriDate.fromDate(newGregorianDate);
  }

  /// Subtracts specified number of days from the current date
  HijriDate subtractDays(int days) {
    return addDays(-days);
  }

  /// Adds specified number of months to the current date
  HijriDate addMonths(int months) {
    int newYear = hYear;
    int newMonth = hMonth + months;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    // Adjust day if it exceeds the days in the new month
    final daysInNewMonth = getDaysInMonth(newYear, newMonth);
    final newDay = hDay > daysInNewMonth ? daysInNewMonth : hDay;

    return HijriDate.fromHijri(newYear, newMonth, newDay);
  }

  /// Subtracts specified number of months from the current date
  HijriDate subtractMonths(int months) {
    return addMonths(-months);
  }

  /// Adds specified number of years to the current date
  HijriDate addYears(int years) {
    final newYear = hYear + years;
    final daysInNewMonth = getDaysInMonth(newYear, hMonth);
    final newDay = hDay > daysInNewMonth ? daysInNewMonth : hDay;

    return HijriDate.fromHijri(newYear, hMonth, newDay);
  }

  /// Subtracts specified number of years from the current date
  HijriDate subtractYears(int years) {
    return addYears(-years);
  }

  /// Calculates the difference in days between this date and another date
  int differenceInDays(HijriDate other) {
    final thisGregorian = hijriToGregorian(hYear, hMonth, hDay);
    final otherGregorian =
        hijriToGregorian(other.hYear, other.hMonth, other.hDay);
    return thisGregorian.difference(otherGregorian).inDays;
  }

  /// Calculates the age in years based on current date
  int ageInYears([HijriDate? fromDate]) {
    final reference = fromDate ?? HijriDate.now();
    int age = reference.hYear - hYear;

    // Adjust if birthday hasn't occurred this year
    if (reference.hMonth < hMonth ||
        (reference.hMonth == hMonth && reference.hDay < hDay)) {
      age--;
    }

    return age;
  }

  /// Returns a list of all Hijri dates in the current month
  List<HijriDate> getDatesInMonth() {
    final daysInMonth = getDaysInMonth(hYear, hMonth);
    return List.generate(
        daysInMonth, (index) => HijriDate.fromHijri(hYear, hMonth, index + 1));
  }

  /// Checks if this date is in the same month as another date
  bool isSameMonth(HijriDate other) {
    return hYear == other.hYear && hMonth == other.hMonth;
  }

  /// Checks if this date is in the same year as another date
  bool isSameYear(HijriDate other) {
    return hYear == other.hYear;
  }

  /// Gets the Hijri date in ISO-like format (yyyy-mm-dd)
  String get isoFormat => format(hYear, hMonth, hDay, "yyyy-mm-dd");

  /// Creates a copy of this HijriCalendar instance
  HijriDate copy() {
    return HijriDate.fromHijri(hYear, hMonth, hDay);
  }

  /// Converts to JSON representation
  Map<String, dynamic> toJson() {
    return {
      'year': hYear,
      'month': hMonth,
      'day': hDay,
      'monthName': longMonthName,
      'dayName': dayWeName,
      'weekday': wkDay,
      'lengthOfMonth': lengthOfMonth,
      'language': language,
    };
  }

  /// Creates HijriCalendar from JSON
  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate.fromHijri(
      json['year'] as int,
      json['month'] as int,
      json['day'] as int,
    );
  }

  /// Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HijriDate &&
        other.hYear == hYear &&
        other.hMonth == hMonth &&
        other.hDay == hDay;
  }

  /// Hash code
  @override
  int get hashCode => Object.hash(hYear, hMonth, hDay);

  /// Comparison operators for sorting
  bool operator <(HijriDate other) {
    return isBefore(other.hYear, other.hMonth, other.hDay);
  }

  bool operator <=(HijriDate other) {
    return isBefore(other.hYear, other.hMonth, other.hDay) ||
        isAtSameMomentAs(other.hYear, other.hMonth, other.hDay);
  }

  bool operator >(HijriDate other) {
    return isAfter(other.hYear, other.hMonth, other.hDay);
  }

  bool operator >=(HijriDate other) {
    return isAfter(other.hYear, other.hMonth, other.hDay) ||
        isAtSameMomentAs(other.hYear, other.hMonth, other.hDay);
  }

  // ======================== Moon Phases Methods ========================

  /// حساب طور القمر للتاريخ الهجري الحالي
  /// Returns the moon phase information for the current Hijri date
  MoonPhaseInfo getMoonPhase() {
    return MoonPhaseCalculator.getMoonPhaseForHijri(this);
  }

  /// حساب طور القمر للتاريخ الهجري المحدد
  /// Returns the moon phase information for the specified Hijri date
  static MoonPhaseInfo getMoonPhaseForDate(int year, int month, int day) {
    HijriDate hijriDate = HijriDate.fromHijri(year, month, day);
    return MoonPhaseCalculator.getMoonPhaseForHijri(hijriDate);
  }

  /// الحصول على جميع تواريخ البدر في السنة الهجرية الحالية
  /// Gets all full moon dates in the current Hijri year
  List<HijriDate> getFullMoonDatesThisYear() {
    return MoonPhaseCalculator.getFullMoonDatesInHijriYear(hYear);
  }

  /// الحصول على جميع تواريخ البدر في سنة هجرية محددة
  /// Gets all full moon dates in the specified Hijri year
  static List<HijriDate> getFullMoonDatesInYear(int hijriYear) {
    return MoonPhaseCalculator.getFullMoonDatesInHijriYear(hijriYear);
  }

  /// الحصول على جميع تواريخ المحاق في السنة الهجرية الحالية
  /// Gets all new moon dates in the current Hijri year
  List<HijriDate> getNewMoonDatesThisYear() {
    return MoonPhaseCalculator.getNewMoonDatesInHijriYear(hYear);
  }

  /// الحصول على جميع تواريخ المحاق في سنة هجرية محددة
  /// Gets all new moon dates in the specified Hijri year
  static List<HijriDate> getNewMoonDatesInYear(int hijriYear) {
    return MoonPhaseCalculator.getNewMoonDatesInHijriYear(hijriYear);
  }

  /// تحقق من إمكانية رؤية الهلال للتاريخ الحالي
  /// Checks if the crescent moon is visible for the current date
  bool isHilalVisible({double minimumAltitude = 10.0}) {
    DateTime gregorianDate = hijriToGregorian(hYear, hMonth, hDay);
    return MoonPhaseCalculator.isHilalVisible(gregorianDate,
        minimumAltitude: minimumAltitude);
  }

  /// تحقق من إمكانية رؤية الهلال لتاريخ محدد
  /// Checks if the crescent moon is visible for the specified date
  static bool isHilalVisibleForDate(int year, int month, int day,
      {double minimumAltitude = 10.0}) {
    HijriDate hijriDate = HijriDate.fromHijri(year, month, day);
    DateTime gregorianDate = hijriDate.hijriToGregorian(year, month, day);
    return MoonPhaseCalculator.isHilalVisible(gregorianDate,
        minimumAltitude: minimumAltitude);
  }

  /// احصائيات أطوار القمر في الشهر الهجري الحالي
  /// Gets moon phase statistics for the current Hijri month
  Map<MoonPhase, int> getMoonPhaseStatisticsThisMonth() {
    DateTime startDate = hijriToGregorian(hYear, hMonth, 1);
    int daysInMonth = getDaysInMonth(hYear, hMonth);
    DateTime endDate = hijriToGregorian(hYear, hMonth, daysInMonth);
    return MoonPhaseCalculator.getMoonPhaseStatistics(startDate, endDate);
  }

  /// احصائيات أطوار القمر في شهر هجري محدد
  /// Gets moon phase statistics for the specified Hijri month
  static Map<MoonPhase, int> getMoonPhaseStatisticsForMonth(
      int year, int month) {
    HijriDate hijriDate = HijriDate.fromHijri(year, month, 1);
    DateTime startDate = hijriDate.hijriToGregorian(year, month, 1);
    int daysInMonth = hijriDate.getDaysInMonth(year, month);
    DateTime endDate = hijriDate.hijriToGregorian(year, month, daysInMonth);
    return MoonPhaseCalculator.getMoonPhaseStatistics(startDate, endDate);
  }

  /// الحصول على اسم طور القمر الحالي
  /// Gets the current moon phase name in the specified language
  String getMoonPhaseName({String? language}) {
    MoonPhaseInfo moonInfo = getMoonPhase();
    language ??= HijriDate.language;
    return MoonPhaseCalculator.getPhaseName(moonInfo.phase, language);
  }

  /// تحقق من كون التاريخ الحالي بدر كامل
  /// Checks if the current date is a full moon
  bool isFullMoon() {
    MoonPhaseInfo moonInfo = getMoonPhase();
    return moonInfo.phase == MoonPhase.fullMoon;
  }

  /// تحقق من كون التاريخ الحالي محاق
  /// Checks if the current date is a new moon
  bool isNewMoon() {
    MoonPhaseInfo moonInfo = getMoonPhase();
    return moonInfo.phase == MoonPhase.newMoon;
  }

  /// حساب عدد الأيام حتى البدر التالي
  /// Calculates days until the next full moon
  int daysUntilNextFullMoon() {
    MoonPhaseInfo moonInfo = getMoonPhase();
    DateTime currentGregorian = hijriToGregorian(hYear, hMonth, hDay);
    return moonInfo.nextFullMoon.difference(currentGregorian).inDays;
  }

  /// حساب عدد الأيام حتى المحاق التالي
  /// Calculates days until the next new moon
  int daysUntilNextNewMoon() {
    MoonPhaseInfo moonInfo = getMoonPhase();
    DateTime currentGregorian = hijriToGregorian(hYear, hMonth, hDay);
    return moonInfo.nextNewMoon.difference(currentGregorian).inDays;
  }

  /// معلومات مفصلة عن القمر للتاريخ الحالي
  /// Detailed moon information for the current date
  String moonInfo({String? language}) {
    MoonPhaseInfo moonInfo = getMoonPhase();
    language ??= HijriDate.language;

    String phaseName =
        MoonPhaseCalculator.getPhaseName(moonInfo.phase, language);
    String illumination =
        '${(moonInfo.illumination * 100).toStringAsFixed(1)}%';
    String age = '${moonInfo.age.toStringAsFixed(1)}';

    if (language == 'ar') {
      return 'طور القمر: $phaseName، نسبة الإضاءة: $illumination، العمر: $age يوم';
    } else {
      return 'Moon Phase: $phaseName, Illumination: $illumination, Age: $age days';
    }
  }

  // ======================== Islamic Events Methods ========================

  /// الحصول على المناسبات الإسلامية للتاريخ الحالي
  /// Gets Islamic events for the current date
  List<IslamicEvent> getTodaysEvents() {
    return IslamicEventsManager.getTodaysEvents()
        .where((event) => event.month == hMonth && event.days.contains(hDay))
        .toList();
  }

  /// الحصول على المناسبات الإسلامية لتاريخ محدد
  /// Gets Islamic events for a specific date
  static List<IslamicEvent> getEventsForDate(int month, int day) {
    return IslamicEventsManager.allEvents
        .where((event) => event.month == month && event.days.contains(day))
        .toList();
  }

  /// الحصول على أقرب مناسبة إسلامية قادمة
  /// Gets the next upcoming Islamic event
  IslamicEvent? getNextEvent() {
    return IslamicEventsManager.getNextEvent();
  }

  /// حساب الأيام المتبقية للمناسبة (تقريبي)
  /// Calculates days remaining until an event (approximate)
  int daysUntilEvent(IslamicEvent event) {
    // حساب تقريبي للأيام المتبقية
    int targetMonth = event.month;
    int targetDay = event.days.first;

    if (targetMonth == hMonth && targetDay >= hDay) {
      return targetDay - hDay;
    } else if (targetMonth > hMonth) {
      int daysInCurrentMonth = lengthOfMonth - hDay;
      int daysInBetween = 0;
      for (int m = hMonth + 1; m < targetMonth; m++) {
        daysInBetween += getDaysInMonth(hYear, m);
      }
      return daysInCurrentMonth + daysInBetween + targetDay;
    } else {
      // المناسبة في السنة القادمة
      int daysInCurrentMonth = lengthOfMonth - hDay;
      int daysInRemainingYear = daysLeftInYear - daysInCurrentMonth;
      int daysInTargetMonth = targetDay;
      return daysInCurrentMonth + daysInRemainingYear + daysInTargetMonth;
    }
  }

  /// الحصول على جميع مناسبات الشهر الحالي
  /// Gets all events in the current month
  List<IslamicEvent> getMonthEvents() {
    return IslamicEventsManager.getEventsInMonth(hMonth);
  }

  /// الحصول على جميع مناسبات شهر محدد
  /// Gets all events in a specific month
  static List<IslamicEvent> getEventsForMonth(int month) {
    return IslamicEventsManager.getEventsInMonth(month);
  }

  /// البحث عن مناسبات بالنوع
  /// Search for events by type
  static List<IslamicEvent> getEventsByType(IslamicEventType type) {
    return IslamicEventsManager.getEventsByType(type);
  }

  /// الحصول على الأحاديث المرتبطة بنوع المناسبة
  /// Gets hadiths related to event type
  static List<HadithInfo> getEventHadiths(IslamicEventType eventType) {
    return IslamicEventsManager.getHadithsForEventType(eventType);
  }

  /// الحصول على إحصائيات المناسبات
  /// Gets events statistics
  static Map<String, int> getEventsStatistics() {
    return IslamicEventsManager.getEventsStatistics();
  }

  /// الأيام المتبقية في الشهر الحالي
  /// Days remaining in current month
  int get daysLeftInMonth {
    return lengthOfMonth - hDay;
  }

  /// الأيام المتبقية في السنة الهجرية الحالية
  /// Days remaining in current Hijri year
  int get daysLeftInYear {
    int totalDays = lengthOfYear();
    return totalDays - dayOfYear;
  }

  /// معلومات شاملة عن اليوم الحالي مع المناسبات
  /// Comprehensive information about the current day with events
  String getDayInfo({String? language}) {
    language ??= HijriDate.language;

    List<IslamicEvent> todaysEvents = getTodaysEvents();
    IslamicEvent? nextEvent = getNextEvent();

    String info = '';

    if (language == 'ar') {
      info = 'التاريخ الهجري: ${fullDate()}\n';
      info += 'أيام متبقية في الشهر: $daysLeftInMonth يوم\n';
      info += 'أيام متبقية في السنة: $daysLeftInYear يوم\n';

      if (todaysEvents.isNotEmpty) {
        info += '\nمناسبات اليوم:\n';
        for (var event in todaysEvents) {
          info += '• ${event.titleArabic}\n';
        }
      }

      if (nextEvent != null) {
        int daysUntil = daysUntilEvent(nextEvent);
        info +=
            '\nأقرب مناسبة: ${nextEvent.titleArabic} (خلال $daysUntil يوم)\n';
      }
    } else {
      info = 'Hijri Date: ${fullDate()}\n';
      info += 'Days left in month: $daysLeftInMonth days\n';
      info += 'Days left in year: $daysLeftInYear days\n';

      if (todaysEvents.isNotEmpty) {
        info += '\nToday\'s Events:\n';
        for (var event in todaysEvents) {
          info += '• ${event.titleEnglish}\n';
        }
      }

      if (nextEvent != null) {
        int daysUntil = daysUntilEvent(nextEvent);
        info +=
            '\nNext Event: ${nextEvent.titleEnglish} (in $daysUntil days)\n';
      }
    }

    return info;
  }
}
