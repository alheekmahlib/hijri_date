// 🌙 مثال شامل لمكتبة التاريخ الهجري مع جميع الميزات المدمجة 🌙
// Comprehensive example for Hijri Calendar library with all integrated features
// يحتوي هذا الملف على جميع الأمثلة المدمجة من ملفات مختلفة في مثال واحد شامل

// استخدام الـ import الواحد للمكتبة كاملة
import '../lib/hijri.dart';

void main() {
  print(
      '🌙 مكتبة التاريخ الهجري الشاملة - Comprehensive Hijri Calendar Library 🌙');
  print('=' * 80);
  print('');

  // =====================================================
  // 1. الاستخدام الأساسي - Basic Usage
  // =====================================================
  print('📅 1. الاستخدام الأساسي - Basic Usage');
  print('-' * 50);

  // التاريخ الحالي
  HijriDate.setLocal('ar');
  var today = HijriDate.now();

  print('📅 اليوم: ${today.fullDate()}');
  print('🗓️  التاريخ المختصر: ${today.isoFormat}');
  print(
      '📊 السنة: ${today.hYear} - الشهر: ${today.hMonth} - اليوم: ${today.hDay}');
  print('🕌 الشهر: ${today.getLongMonthName()} (${today.getShortMonthName()})');
  print('📝 يوم الأسبوع: ${today.getDayName()}');
  print('📏 أيام الشهر: ${today.lengthOfMonth} يوم');
  print('📈 أيام السنة: ${today.lengthOfYear()} يوم');
  print('📍 يوم السنة: ${today.dayOfYear}');
  print('📆 أسبوع السنة: ${today.weekOfYear}');
  print('🌟 سنة كبيسة؟ ${today.isLeapYear ? "نعم" : "لا"}');
  print('🏠 عطلة نهاية أسبوع؟ ${today.isWeekend ? "نعم" : "لا"}');
  print('');

  // =====================================================
  // 2. التحويل بين التقاويم - Date Conversion
  // =====================================================
  print('🔄 2. التحويل بين التقاويم - Date Conversion');
  print('-' * 50);

  // من الميلادي إلى الهجري
  var gregorianDate = DateTime(2024, 3, 10);
  var hijriFromGregorian = HijriDate.fromDate(gregorianDate);
  print(
      '📅 ${gregorianDate.day}/${gregorianDate.month}/${gregorianDate.year} م = ${hijriFromGregorian.fullDate()}');

  // من الهجري إلى الميلادي
  var hijriDate = HijriDate.fromHijri(1445, 9, 15);
  var gregorianFromHijri = hijriDate.hijriToGregorian(1445, 9, 15);
  print(
      '📅 ${hijriDate.fullDate()} = ${gregorianFromHijri.day}/${gregorianFromHijri.month}/${gregorianFromHijri.year} م');
  print('');

  // =====================================================
  // 3. التنسيق المتقدم - Advanced Formatting
  // =====================================================
  print('🎨 3. التنسيق المتقدم - Advanced Formatting');
  print('-' * 50);

  print('📝 أنماط التنسيق المختلفة:');
  print('   • dd/mm/yyyy: ${today.toFormat("dd/mm/yyyy")}');
  print('   • DDDD, MMMM dd, yyyy: ${today.toFormat("DDDD, MMMM dd, yyyy")}');
  print('   • DD MM yy: ${today.toFormat("DD MM yy")}');
  print('   • d MMMM yyyy: ${today.toFormat("d MMMM yyyy")}');
  print('   • الكامل: ${today.fullDate()}');
  print('   • ISO: ${today.isoFormat}');
  print('');

  // =====================================================
  // 4. العمليات الحسابية - Date Arithmetic
  // =====================================================
  print('🧮 4. العمليات الحسابية - Date Arithmetic');
  print('-' * 50);

  var futureDate = today.addDays(30);
  var pastDate = today.subtractDays(15);
  var nextMonth = today.addMonths(2);
  var nextYear = today.addYears(1);

  print('📅 اليوم: ${today.fullDate()}');
  print('➕ بعد 30 يوم: ${futureDate.fullDate()}');
  print('➖ قبل 15 يوم: ${pastDate.fullDate()}');
  print('📆 بعد شهرين: ${nextMonth.fullDate()}');
  print('🗓️  العام القادم: ${nextYear.fullDate()}');
  print('📊 الفرق بالأيام: ${today.differenceInDays(futureDate)} يوم');
  print('');

  // =====================================================
  // 5. مقارنة التواريخ - Date Comparison
  // =====================================================
  print('⚖️  5. مقارنة التواريخ - Date Comparison');
  print('-' * 50);

  var date1 = HijriDate.fromHijri(1445, 6, 15);
  var date2 = HijriDate.fromHijri(1445, 8, 20);

  print('📅 التاريخ الأول: ${date1.fullDate()}');
  print('📅 التاريخ الثاني: ${date2.fullDate()}');
  print('🔍 date1 < date2: ${date1 < date2}');
  print('🔍 date1 > date2: ${date1 > date2}');
  print('🔍 date1 == date2: ${date1 == date2}');
  print('🔍 نفس الشهر: ${date1.isSameMonth(date2)}');
  print('🔍 نفس السنة: ${date1.isSameYear(date2)}');
  print('');

  // =====================================================
  // 6. دعم اللغات المتعددة - Multi-language Support
  // =====================================================
  print('🌍 6. دعم اللغات المتعددة - Multi-language Support');
  print('-' * 50);

  Map<String, String> languages = {
    'ar': 'العربية',
    'en': 'English',
    'tr': 'Türkçe',
    'id': 'Indonesia',
    'ms': 'Melayu',
    'fil': 'Filipino',
    'bn': 'বাংলা',
    'ur': 'اردو',
  };

  var sampleDate = HijriDate.fromHijri(1445, 9, 15);
  for (var entry in languages.entries) {
    HijriDate.setLocal(entry.key);
    print(
        '🏳️  ${entry.value}: ${sampleDate.fullDate()} | ${sampleDate.toFormat("dd/mm/yyyy")}');
  }
  print('');

  // =====================================================
  // 7. تحويل الأرقام - Number Conversion
  // =====================================================
  print('🔢 7. تحويل الأرقام - Number Conversion');
  print('-' * 50);

  int sampleNumber = 12345;
  print('🔢 الرقم الأصلي: $sampleNumber');
  print('🌍 بلغات مختلفة:');
  for (var entry in languages.entries) {
    String converted =
        DigitsConverter.convertNumberToLocale(sampleNumber, entry.key);
    print('   • ${entry.value}: $converted');
  }
  print('');

  // =====================================================
  // 8. أطوار القمر - Moon Phases
  // =====================================================
  print('🌙 8. أطوار القمر - Moon Phases');
  print('-' * 50);

  HijriDate.setLocal('ar');
  var moonInfo = today.getMoonPhase();
  print('🌙 طور القمر اليوم: ${today.getMoonPhaseName()}');
  print(
      '💡 نسبة الإضاءة: ${(moonInfo.illumination * 100).toStringAsFixed(1)}%');
  print('📅 عمر القمر: ${moonInfo.age.toStringAsFixed(1)} يوم');
  print('🌕 هل هو بدر؟ ${today.isFullMoon() ? "نعم" : "لا"}');
  print('🌑 هل هو محاق؟ ${today.isNewMoon() ? "نعم" : "لا"}');
  print('🌙 يمكن رؤية الهلال؟ ${today.isHilalVisible() ? "نعم" : "لا"}');
  print('⏳ البدر التالي بعد: ${today.daysUntilNextFullMoon()} يوم');
  print('⏳ المحاق التالي بعد: ${today.daysUntilNextNewMoon()} يوم');

  // إحصائيات أطوار القمر للشهر
  var moonStats = today.getMoonPhaseStatisticsThisMonth();
  print('📊 إحصائيات أطوار القمر للشهر:');
  moonStats.forEach((phase, count) {
    if (count > 0) {
      String phaseName = MoonPhaseCalculator.getPhaseName(phase, 'ar');
      print('   • $phaseName: $count أيام');
    }
  });
  print('');

  // =====================================================
  // 9. المناسبات الإسلامية - Islamic Events
  // =====================================================
  print('🕌 9. المناسبات الإسلامية - Islamic Events');
  print('-' * 50);

  // مناسبات اليوم
  var todaysEvents = IslamicEventsManager.getTodaysEvents();
  if (todaysEvents.isNotEmpty) {
    print('🎉 مناسبات اليوم:');
    for (var event in todaysEvents) {
      print('   ✨ ${event.getTitle('ar')}');
      print('   ✨ ${event.getTitle('en')}');
    }
  } else {
    print('📝 لا توجد مناسبات خاصة اليوم');
  }

  // أقرب مناسبة قادمة
  var nextEvent = IslamicEventsManager.getNextEvent();
  if (nextEvent != null) {
    int daysUntil = nextEvent.daysUntilEvent();
    print('⏰ أقرب مناسبة قادمة:');
    print('   🎯 ${nextEvent.getTitle('ar')}');
    print('   🎯 ${nextEvent.getTitle('en')}');
    print('   ⏳ خلال $daysUntil يوم');

    if (nextEvent.hadiths.isNotEmpty) {
      print('   📜 حديث مرتبط:');
      var hadith = nextEvent.hadiths.first;
      String shortHadith = hadith.hadith.length > 100
          ? hadith.hadith.substring(0, 100) + '...'
          : hadith.hadith;
      print('   $shortHadith');
      print('   📚 ${hadith.bookInfo}');
    }
  }

  // مناسبات رمضان
  var ramadanEvents = IslamicEventsManager.getEventsInMonth(9);
  print('🌙 مناسبات شهر رمضان:');
  for (var event in ramadanEvents) {
    print('   🕌 ${event.getTitle('ar')} - أيام: ${event.days.join(', ')}');
  }

  // إحصائيات المناسبات
  var eventsStats = IslamicEventsManager.getEventsStatistics();
  print('📊 إحصائيات المناسبات:');
  eventsStats.forEach((key, value) {
    print('   • $key: $value');
  });
  print('');

  // =====================================================
  // 10. الأدوات المساعدة - Utility Functions
  // =====================================================
  print('🛠️  10. الأدوات المساعدة - Utility Functions');
  print('-' * 50);

  // حساب العمر
  var birthDate = HijriDate.fromHijri(1400, 5, 15);
  var detailedAge = AgeCalculator.calculateDetailedAge(birthDate, today);
  var ageCategory = AgeCalculator.getAgeCategory(detailedAge['years']!, 'ar');

  print('👶 حساب العمر:');
  print('   📅 تاريخ الميلاد: ${birthDate.fullDate()}');
  print(
      '   🎂 العمر: ${detailedAge['years']} سنة، ${detailedAge['months']} شهر، ${detailedAge['days']} يوم');
  print('   👤 فئة العمر: $ageCategory');

  // معلومات الفصول
  var season = HijriUtils.getSeason(today.hMonth, 'ar');
  print('🌱 الفصل الحالي: $season');

  // أيام الجمعة في الشهر
  var fridays = HijriUtils.getFridaysInMonth(today.hYear, today.hMonth);
  print('🕌 أيام الجمعة في الشهر:');
  for (var friday in fridays.take(2)) {
    print(
        '   • ${friday.format(friday.hYear, friday.hMonth, friday.hDay, "dd MMMM")}');
  }
  if (fridays.length > 2) {
    print('   • ... و ${fridays.length - 2} يوم جمعة آخر');
  }

  // أيام الصيام المستحبة
  var fastingDays = PrayerTimeHelper.getRecommendedFastingDays(today.hMonth);
  print('🍽️ أيام الصيام المستحبة: ${fastingDays.join(', ')}');
  print('');

  // =====================================================
  // 11. التحقق من صحة التواريخ - Date Validation
  // =====================================================
  print('✅ 11. التحقق من صحة التواريخ - Date Validation');
  print('-' * 50);

  // تاريخ صحيح
  try {
    var validDate = HijriDate.fromHijri(1445, 9, 15);
    print('✅ تاريخ صحيح: ${validDate.fullDate()}');
    print('🔍 صالح؟ ${validDate.isValid()}');
  } catch (e) {
    print('❌ خطأ: $e');
  }

  // تاريخ غير صحيح
  try {
    HijriDate.fromHijri(1445, 1, 35); // يوم غير موجود
    print('❌ لن تصل إلى هنا');
  } catch (e) {
    String errorMsg = e.toString();
    if (errorMsg.contains('Exception: ')) {
      errorMsg = errorMsg.split('Exception: ')[1];
    }
    print('⚠️  تاريخ غير صحيح: $errorMsg');
  }

  // تاريخ خارج النطاق
  try {
    HijriDate.fromHijri(1600, 1, 1); // سنة خارج النطاق
    print('❌ لن تصل إلى هنا');
  } catch (e) {
    String errorMsg = e.toString();
    if (errorMsg.contains('Exception: ')) {
      errorMsg = errorMsg.split('Exception: ')[1];
    }
    print('⚠️  خارج النطاق: $errorMsg');
  }
  print('');

  // =====================================================
  // 12. التسلسل والاستيراد - Serialization
  // =====================================================
  print('💾 12. التسلسل والاستيراد - Serialization');
  print('-' * 50);

  // تصدير إلى JSON
  var jsonData = today.toJson();
  print('📤 JSON: $jsonData');

  // استيراد من JSON
  var fromJson = HijriDate.fromJson(jsonData);
  print('📥 من JSON: ${fromJson.fullDate()}');
  print('🔍 متطابق؟ ${today == fromJson}');

  // استخدام extension لتحويل الأرقام في النص المختلط
  String mixedText =
      'Today is ${today.hDay}/${today.hMonth}/${today.hYear} - اليوم هو ${today.hDay}/${today.hMonth}/${today.hYear}';
  print('📝 النص الأصلي: $mixedText');
  print('🔤 بالأرقام العربية: ${mixedText.convertNumbers('ar')}');
  print('🔤 بالأرقام البنغالية: ${mixedText.convertNumbers('bn')}');
  print('🔤 بالأرقام الأردية: ${mixedText.convertNumbers('ur')}');
  print('');

  // =====================================================
  // 13. التعديلات والضبط - Adjustments
  // =====================================================
  print('⚙️  13. التعديلات والضبط - Adjustments');
  print('-' * 50);

  // بدون تعديل
  var defaultCal = HijriDate.fromDate(DateTime(2020, 8, 20));
  print('📅 افتراضي: ${defaultCal.fullDate()}');

  // مع التعديل
  var adjustedCal = HijriDate();
  adjustedCal.setAdjustments({17292: 59083}); // 30 يوم بدلاً من 29
  adjustedCal.gregorianToHijri(2020, 8, 20);
  print('🔧 معدّل: ${adjustedCal.fullDate()}');
  print('📊 الفرق: ${defaultCal.differenceInDays(adjustedCal)} أيام');
  print('');

  // =====================================================
  // 14. أمثلة متقدمة - Advanced Examples
  // =====================================================
  print('🚀 14. أمثلة متقدمة - Advanced Examples');
  print('-' * 50);

  print('📈 إحصائيات شاملة:');
  print(
      '   🌙 أطوار القمر هذا الشهر: ${moonStats.values.fold(0, (a, b) => a + b)} يوم');
  print('   🕌 مناسبات إسلامية هذا العام: ${eventsStats['totalEvents']}');
  print('   🌍 لغات مدعومة: ${DigitsConverter.getSupportedLocales().length}');
  print('   📅 نطاق السنوات: 1356-1500 هـ');

  // تواريخ مهمة
  print('📅 تواريخ مهمة هذا العام:');
  var importantEvents = [
    IslamicEventsManager.findEventsByType(IslamicEventType.eidAlFitr),
    IslamicEventsManager.findEventsByType(IslamicEventType.eidAlAdha),
    IslamicEventsManager.findEventsByType(IslamicEventType.arafah),
  ].expand((x) => x).toList();

  for (var event in importantEvents.take(3)) {
    int daysUntil = event.daysUntilEvent();
    print('   🎯 ${event.getTitle('ar')}: $daysUntil يوم');
  }

  // =====================================================
  // 15. الأحاديث والمعلومات الدينية - Hadiths & Religious Info
  // =====================================================
  print('\n📜 15. الأحاديث والمعلومات الدينية - Hadiths & Religious Info');
  print('-' * 50);

  // البحث عن حدث به أحاديث
  var eventWithHadith =
      IslamicEventsManager.findEventsByType(IslamicEventType.eidAlFitr).first;
  if (eventWithHadith.hadiths.isNotEmpty) {
    print('🎉 مناسبة: ${eventWithHadith.getTitle('ar')}');
    print('📜 الأحاديث المرتبطة:');
    for (int i = 0; i < eventWithHadith.hadiths.length && i < 2; i++) {
      var hadith = eventWithHadith.hadiths[i];
      String shortHadith = hadith.hadith.length > 150
          ? hadith.hadith.substring(0, 150) + '...'
          : hadith.hadith;
      print('   ${i + 1}. $shortHadith');
      print('      📚 المصدر: ${hadith.bookInfo}');
      print('      📖 المرجع: ${hadith.bookInfo}');
    }
  }

  // =====================================================
  // 16. اختبار الأداء - Performance Testing
  // =====================================================
  print('\n⚡ 16. اختبار الأداء - Performance Testing');
  print('-' * 50);

  Stopwatch stopwatch = Stopwatch()..start();

  // اختبار سرعة التحويل
  for (int i = 0; i < 1000; i++) {
    HijriDate.fromDate(DateTime(2024, 1, 1).add(Duration(days: i)));
  }
  stopwatch.stop();
  print('🚀 تحويل 1000 تاريخ: ${stopwatch.elapsedMilliseconds} مللي ثانية');

  // اختبار سرعة حساب أطوار القمر
  stopwatch.reset();
  stopwatch.start();
  for (int i = 0; i < 100; i++) {
    today.addDays(i).getMoonPhase();
  }
  stopwatch.stop();
  print('🌙 حساب 100 طور قمر: ${stopwatch.elapsedMilliseconds} مللي ثانية');

  // اختبار سرعة تحويل الأرقام
  stopwatch.reset();
  stopwatch.start();
  String testNumber = '1234567890';
  for (int i = 0; i < 1000; i++) {
    testNumber.convertNumbers('ar');
  }
  stopwatch.stop();
  print('🔢 تحويل 1000 رقم: ${stopwatch.elapsedMilliseconds} مللي ثانية');

  // =====================================================
  // 17. معلومات النظام - System Information
  // =====================================================
  print('\n💻 17. معلومات النظام - System Information');
  print('-' * 50);

  print('📦 معلومات المكتبة:');
  print('   📋 الاسم: Hijri Calendar Library');
  print('   🏷️  الإصدار: 1.0.0');
  print('   👨‍💻 المطور: Islamic Development Community');
  print('   🌐 الدعم: 8 لغات مختلفة');
  print('   🎯 الميزات: ${[
    'التقويم الهجري الدقيق',
    'أطوار القمر الفلكية',
    'المناسبات الإسلامية',
    'دعم متعدد اللغات',
    'الأحاديث النبوية',
    'حساب العمر',
    'التحويل بين التقاويم'
  ].length} ميزة رئيسية');

  // الذاكرة المستخدمة (تقديري)
  var memoryInfo = {
    'تواريخ محفوظة': 'معدود',
    'أحداث إسلامية': '${IslamicEventsManager.allEvents.length}',
    'لغات مدعومة': '${DigitsConverter.getSupportedLocales().length}',
    'تعديلات التقويم': 'حسب الحاجة'
  };

  print('   💾 استخدام الذاكرة:');
  memoryInfo.forEach((key, value) {
    print('      • $key: $value');
  });

  print('');
  print('=' * 80);
  print('✨ انتهى المثال الشامل - تم عرض جميع ميزات المكتبة بنجاح! ✨');
  print(
      '✨ Comprehensive example completed - All library features demonstrated! ✨');
  print('=' * 80);
  print('');
  print(
      '🤲 "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"');
  print(
      '🤲 "Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire."');

  // إعادة تعيين اللغة للإنجليزية
  HijriDate.setLocal('en');
}
