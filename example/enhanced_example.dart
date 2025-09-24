import '../lib/hijri_calendar.dart';
import '../lib/hijri_utils.dart';

void main() {
  print('=== مكتبة التاريخ الهجري المحسنة ===\n');

  // استخدام أساسي
  print('1. الاستخدام الأساسي:');
  final today = HijriCalendar.now();
  print('اليوم: ${today.fullDate()}');
  print('التاريخ المختصر: ${today.isoFormat}');
  print('اليوم في السنة: ${today.dayOfYear}');
  print('الأسبوع في السنة: ${today.weekOfYear}');
  print('هل هي سنة كبيسة؟ ${today.isLeapYear ? "نعم" : "لا"}');
  print('هل هو عطلة نهاية أسبوع؟ ${today.isWeekend ? "نعم" : "لا"}\n');

  // العمليات الحسابية على التواريخ
  print('2. العمليات الحسابية:');
  final futureDate = today.addDays(30);
  print('بعد 30 يوم: ${futureDate.fullDate()}');

  final pastDate = today.subtractMonths(6);
  print('قبل 6 أشهر: ${pastDate.fullDate()}');

  final nextYear = today.addYears(1);
  print('العام القادم: ${nextYear.fullDate()}');

  print(
      'الفرق بالأيام بين اليوم وبعد شهر: ${today.differenceInDays(today.addDays(30))} يوم\n');

  // المقارنات
  print('3. مقارنة التواريخ:');
  final date1 = HijriCalendar.fromHijri(1445, 6, 15);
  final date2 = HijriCalendar.fromHijri(1445, 8, 20);

  print('التاريخ الأول: ${date1.fullDate()}');
  print('التاريخ الثاني: ${date2.fullDate()}');
  print('التاريخ الأول أقل من الثاني؟ ${date1 < date2}');
  print('التاريخان متساويان؟ ${date1 == date2}');
  print('هل في نفس الشهر؟ ${date1.isSameMonth(date2)}');
  print('هل في نفس السنة؟ ${date1.isSameYear(date2)}\n');

  // حساب العمر
  print('4. حساب العمر:');
  final birthDate = HijriCalendar.fromHijri(1400, 3, 12);
  final age = birthDate.ageInYears();
  final detailedAge = AgeCalculator.calculateDetailedAge(birthDate);

  print('تاريخ الميلاد: ${birthDate.fullDate()}');
  print('العمر: $age سنة');
  print(
      'العمر التفصيلي: ${detailedAge['years']} سنة، ${detailedAge['months']} شهر، ${detailedAge['days']} يوم');
  print('فئة العمر: ${AgeCalculator.getAgeCategory(age, 'ar')}\n');

  // الأحداث الإسلامية
  print('5. الأحداث الإسلامية:');
  final ashura = HijriCalendar.fromHijri(1445, 1, 10);
  final eidFitr = HijriCalendar.fromHijri(1445, 10, 1);

  final ashuraEvent = IslamicEvents.getEventForDate(ashura);
  final eidEvent = IslamicEvents.getEventForDate(eidFitr);

  if (ashuraEvent != null) {
    print(
        '${ashura.format(1445, 1, 10, "dd/mm/yyyy")}: ${ashuraEvent['name']}');
  }

  if (eidEvent != null) {
    print('${eidFitr.format(1445, 10, 1, "dd/mm/yyyy")}: ${eidEvent['name']}');
  }

  print(
      'هل يوم عاشوراء يوم صيام مستحب؟ ${PrayerTimeHelper.isRecommendedFastingDay(ashura)}\n');

  // المواسم والفصول
  print('6. المواسم والفصول:');
  final ramadan = HijriCalendar.fromHijri(1445, 9, 15);
  print('شهر رمضان في فصل: ${HijriUtils.getSeason(ramadan.hMonth, 'ar')}\n');

  // الجُمع في الشهر
  print('7. جميع أيام الجمعة في شهر محرم 1445:');
  final fridays = HijriUtils.getFridaysInMonth(1445, 1);
  for (final friday in fridays) {
    print('- ${friday.fullDate()}');
  }
  print('');

  // نطاق التواريخ
  print('8. نطاق التواريخ:');
  final startDate = HijriCalendar.fromHijri(1445, 1, 1);
  final endDate = HijriCalendar.fromHijri(1445, 1, 7);
  final dateRange = HijriUtils.getDateRange(startDate, endDate);

  print('الأسبوع الأول من محرم 1445:');
  for (final date in dateRange) {
    print(
        '- ${date.format(date.hYear, date.hMonth, date.hDay, "DDDD dd/mm/yyyy")}');
  }
  print('');

  // تصدير واستيراد JSON
  print('9. التسلسل إلى JSON:');
  final jsonData = today.toJson();
  print('JSON: $jsonData');

  final fromJson = HijriCalendar.fromJson(jsonData);
  print('استرجاع من JSON: ${fromJson.fullDate()}\n');

  // اللغات المختلفة
  print('10. دعم اللغات المختلفة:');

  // العربية
  HijriCalendar.setLocal('ar');
  final arabicDate = HijriCalendar.now();
  print('العربية: ${arabicDate.fullDate()}');

  // الإنجليزية
  HijriCalendar.setLocal('en');
  final englishDate = HijriCalendar.now();
  print('English: ${englishDate.fullDate()}');

  // التركية
  HijriCalendar.setLocal('tr');
  final turkishDate = HijriCalendar.now();
  print('Türkçe: ${turkishDate.fullDate()}\n');

  // إحصائيات الشهر
  print('11. إحصائيات الشهر الحالي:');
  final currentMonth = HijriCalendar.now();
  final firstDay = currentMonth.firstDayOfMonth;
  final lastDay = currentMonth.lastDayOfMonth;
  final datesInMonth = currentMonth.getDatesInMonth();

  print('أول يوم في الشهر: ${firstDay.fullDate()}');
  print('آخر يوم في الشهر: ${lastDay.fullDate()}');
  print('عدد أيام الشهر: ${datesInMonth.length}');
  print('الأحداث في هذا الشهر:');

  final monthEvents = IslamicEvents.getEventsInMonth(currentMonth.hMonth);
  for (final event in monthEvents) {
    print('- ${event['day']}/${currentMonth.hMonth}: ${event['name']}');
  }

  print('\n=== انتهى المثال ===');
}
