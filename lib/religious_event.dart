import 'hijri_date.dart';

/// نوع المناسبة الإسلامية
enum IslamicEventType {
  newYear, // بداية السنة الهجرية
  tasooaReminder, // تذكير صيام تاسوعاء
  ashuraReminder, // تذكير صيام عاشوراء
  ashura, // يوم عاشوراء
  ramadan, // بداية رمضان
  laylatAlQadr, // ليلة القدر
  eidAlFitr, // عيد الفطر
  sixOfShawwal, // صيام ستة شوال
  arafahReminder, // تذكير صيام عرفة
  arafah, // يوم عرفة
  tenDaysOfDhulHijjah, // عشر ذي الحجة
  eidAlAdha, // عيد الأضحى
}

/// معلومات الحديث
class HadithInfo {
  final String hadith;
  final String bookInfo;

  const HadithInfo({
    required this.hadith,
    required this.bookInfo,
  });
}

/// المناسبة الإسلامية
class IslamicEvent {
  final int id;
  final IslamicEventType type;
  final String titleArabic;
  final String titleEnglish;
  final int month;
  final List<int> days;
  final bool isReminder;
  final List<HadithInfo> hadiths;

  const IslamicEvent({
    required this.id,
    required this.type,
    required this.titleArabic,
    required this.titleEnglish,
    required this.month,
    required this.days,
    required this.isReminder,
    required this.hadiths,
  });

  /// حساب الأيام المتبقية للمناسبة
  int daysUntilEvent() {
    final now = DateTime.now();
    final currentHijri = HijriDate.fromDate(now);

    // البحث عن أقرب يوم للمناسبة
    int minDays = 999999;

    for (int day in days) {
      // جرب السنة الحالية
      DateTime eventDate = _calculateEventDate(currentHijri.hYear, month, day);
      int daysUntil = eventDate.difference(now).inDays;

      if (daysUntil >= 0 && daysUntil < minDays) {
        minDays = daysUntil;
      }

      // إذا لم نجد في السنة الحالية، جرب السنة القادمة
      if (daysUntil < 0) {
        eventDate = _calculateEventDate(currentHijri.hYear + 1, month, day);
        daysUntil = eventDate.difference(now).inDays;

        if (daysUntil < minDays) {
          minDays = daysUntil;
        }
      }
    }

    return minDays == 999999 ? 0 : minDays;
  }

  DateTime _calculateEventDate(int year, int month, int day) {
    final hijri = HijriDate();
    return hijri.hijriToGregorian(year, month, day);
  }

  /// التحقق من كون اليوم هو يوم المناسبة
  bool isToday() {
    final now = DateTime.now();
    final currentHijri = HijriDate.fromDate(now);

    return month == currentHijri.hMonth && days.contains(currentHijri.hDay);
  }

  /// التحقق من كون المناسبة في الشهر الحالي
  bool isThisMonth() {
    final currentHijri = HijriDate.fromDate(DateTime.now());
    return month == currentHijri.hMonth;
  }

  /// الحصول على العنوان حسب اللغة
  String getTitle([String language = 'ar']) {
    return language == 'ar' ? titleArabic : titleEnglish;
  }
}

/// مدير المناسبات الإسلامية
class IslamicEventsManager {
  static const List<IslamicEvent> _events = [
    IslamicEvent(
      id: 1,
      type: IslamicEventType.newYear,
      titleArabic: "بداية السنة الهجرية",
      titleEnglish: "Islamic New Year",
      month: 1,
      days: [1],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "كان أصحابُ النَّبيِّ صلَّى اللَّهُ عليهِ وآلِهِ وسلَّمَ يَتعلَّمونَ الدُّعاءَ كمَا يتعلَّمونَ القُرْآنَ إذا دخل الشَّهرُ أوِ السَّنةُ : \"اللَّهُمَّ أدْخِلْهُ علينا بالأمْنِ والإيمَانِ والسَّلامَةِ والإسْلامِ وجِوارٍ منَ الشَّيطَانِ ورِضْوانٍ مَنَ الرَّحمَنِ\".",
          bookInfo:
              "الراوي : عبدالله بن هشام | المحدث : ابن حجر العسقلاني | المصدر : الإصابة في تمييز الصحابة\nالصفحة أو الرقم : 2/378 | خلاصة حكم المحدث : موقوف على شرط الصحيح",
        ),
      ],
    ),
    IslamicEvent(
      id: 2,
      type: IslamicEventType.tasooaReminder,
      titleArabic: "تذكير صيام تاسوعاء",
      titleEnglish: "Tasoo'a Fasting Reminder",
      month: 1,
      days: [8],
      isReminder: true,
      hadiths: [
        HadithInfo(
          hadith:
              "حِينَ صَامَ رَسولُ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ يَومَ عَاشُورَاءَ وَأَمَرَ بصِيَامِهِ قالوا: يا رَسولَ اللهِ، إنَّه يَوْمٌ تُعَظِّمُهُ اليَهُودُ وَالنَّصَارَى، فَقالَ رَسولُ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ: \"فَإِذَا كانَ العَامُ المُقْبِلُ -إنْ شَاءَ اللَّهُ- صُمْنَا اليومَ التَّاسِعَ\"، قالَ: فَلَمْ يَأْتِ العَامُ المُقْبِلُ حتَّى تُوُفِّيَ رَسولُ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ.",
          bookInfo:
              "الراوي : عبدالله بن عباس | المحدث : مسلم | المصدر : صحيح مسلم\nالصفحة أو الرقم : 1134 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 3,
      type: IslamicEventType.ashuraReminder,
      titleArabic: "تذكير صيام عاشوراء",
      titleEnglish: "Ashura Fasting Reminder",
      month: 1,
      days: [9],
      isReminder: true,
      hadiths: [
        HadithInfo(
          hadith:
              "قَدِمَ رَسولُ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ المَدِينَةَ، فَوَجَدَ اليَهُودَ يَصُومُونَ يَومَ عَاشُورَاءَ فَسُئِلُوا عن ذلكَ؟ فَقالوا: هذا اليَوْمُ الذي أَظْهَرَ اللَّهُ فيه مُوسَى، وَبَنِي إسْرَائِيلَ علَى فِرْعَوْنَ، فَنَحْنُ نَصُومُهُ تَعْظِيمًا له، فَقالَ النبيُّ صَلَّى اللَّهُ عليه وسلَّمَ: \"نَحْنُ أَوْلَى بمُوسَى مِنكُم فأمَرَ بصَوْمِهِ\".",
          bookInfo:
              "الراوي : عبدالله بن عباس | المحدث : مسلم | المصدر : صحيح مسلم\nالصفحة أو الرقم : 1130 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 4,
      type: IslamicEventType.ashura,
      titleArabic: "يوم عاشوراء",
      titleEnglish: "Day of Ashura",
      month: 1,
      days: [10],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "قَدِمَ رَسولُ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ المَدِينَةَ، فَوَجَدَ اليَهُودَ يَصُومُونَ يَومَ عَاشُورَاءَ فَسُئِلُوا عن ذلكَ؟ فَقالوا: هذا اليَوْمُ الذي أَظْهَرَ اللَّهُ فيه مُوسَى، وَبَنِي إسْرَائِيلَ علَى فِرْعَوْنَ، فَنَحْنُ نَصُومُهُ تَعْظِيمًا له، فَقالَ النبيُّ صَلَّى اللَّهُ عليه وسلَّمَ: \"نَحْنُ أَوْلَى بمُوسَى مِنكُم فأمَرَ بصَوْمِهِ\".",
          bookInfo:
              "الراوي : عبدالله بن عباس | المحدث : مسلم | المصدر : صحيح مسلم\nالصفحة أو الرقم : 1130 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 5,
      type: IslamicEventType.ramadan,
      titleArabic: "بداية شهر رمضان المبارك",
      titleEnglish: "Beginning of Ramadan",
      month: 9,
      days: [1],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "مَن قَامَ رَمَضَانَ إيمَانًا واحْتِسَابًا، غُفِرَ له ما تَقَدَّمَ مِن ذَنْبِهِ.",
          bookInfo:
              "الراوي : أبو هريرة | المحدث : البخاري | المصدر : صحيح البخاري\nالصفحة أو الرقم : 37 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 6,
      type: IslamicEventType.laylatAlQadr,
      titleArabic: "ليلة القدر (العشر الأواخر من رمضان)",
      titleEnglish: "Night of Power (Last 10 nights of Ramadan)",
      month: 9,
      days: [20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
      isReminder: true,
      hadiths: [
        HadithInfo(
          hadith:
              "أنَّ رَسولَ اللَّهِ صَلَّى اللهُ عليه وسلَّمَ قَالَ: تَحَرَّوْا لَيْلَةَ القَدْرِ في الوِتْرِ مِنَ العَشْرِ الأوَاخِرِ مِن رَمَضَانَ.",
          bookInfo:
              "الراوي : عائشة أم المؤمنين | المحدث : البخاري | المصدر : صحيح البخاري\nالصفحة أو الرقم : 2017 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 7,
      type: IslamicEventType.eidAlFitr,
      titleArabic: "عيد الفطر المبارك",
      titleEnglish: "Eid Al-Fitr",
      month: 10,
      days: [1, 2, 3],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "كان أصحابُ رسولِ اللهِ صلَّى اللهُ عليْهِ وسلَّمَ إذا التقوْا يومَ العيدِ يقولُ بعضُهم لبعضٍ : \"تقبل اللهُ منَّا ومنكَ\"",
          bookInfo:
              "الراوي : جبير بن نفير | المحدث : ابن حجر العسقلاني | المصدر : فتح الباري لابن حجر\nالصفحة أو الرقم : 2/517 | خلاصة حكم المحدث : إسناده حسن",
        ),
      ],
    ),
    IslamicEvent(
      id: 8,
      type: IslamicEventType.sixOfShawwal,
      titleArabic: "صيام الست من شوال",
      titleEnglish: "Six Days of Shawwal Fasting",
      month: 10,
      days: [
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23
      ],
      isReminder: true,
      hadiths: [
        HadithInfo(
          hadith:
              "مَن صامَ رَمَضانَ ثُمَّ أتْبَعَهُ سِتًّا مِن شَوَّالٍ، كانَ كَصِيامِ الدَّهْرِ.",
          bookInfo:
              "الراوي : أبو أيوب الأنصاري | المحدث : مسلم | المصدر : صحيح مسلم\nالصفحة أو الرقم : 1164 | خلاصة حكم المحدث : [صحيح]",
        ),
      ],
    ),
    IslamicEvent(
      id: 9,
      type: IslamicEventType.arafahReminder,
      titleArabic: "تذكير صيام يوم عرفة",
      titleEnglish: "Arafah Fasting Reminder",
      month: 12,
      days: [8],
      isReminder: true,
      hadiths: [
        HadithInfo(
          hadith:
              "صيامُ يومِ عَرفةَ إنّي أحْتسبُ على اللهِ أن يُكفّرَ السنَةَ التي بعدهُ ، والسنةَ التي قبلهُ.",
          bookInfo:
              "الراوي : أبو قتادة الحارث بن ربعي | المحدث : الترمذي | المصدر : سنن الترمذي\nالصفحة أو الرقم : 749 | خلاصة حكم المحدث : حسن",
        ),
      ],
    ),
    IslamicEvent(
      id: 10,
      type: IslamicEventType.arafah,
      titleArabic: "يوم عرفة",
      titleEnglish: "Day of Arafah",
      month: 12,
      days: [9],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "صيامُ يومِ عَرفةَ إنّي أحْتسبُ على اللهِ أن يُكفّرَ السنَةَ التي بعدهُ ، والسنةَ التي قبلهُ.",
          bookInfo:
              "الراوي : أبو قتادة الحارث بن ربعي | المحدث : الترمذي | المصدر : سنن الترمذي\nالصفحة أو الرقم : 749 | خلاصة حكم المحدث : حسن",
        ),
      ],
    ),
    IslamicEvent(
      id: 11,
      type: IslamicEventType.tenDaysOfDhulHijjah,
      titleArabic: "العشر الأوائل من ذي الحجة",
      titleEnglish: "First Ten Days of Dhul-Hijjah",
      month: 12,
      days: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "ما العملُ في أيَّامٍ أفضلُ منه في \"عشْرِ ذي الحجَّةِ\"، قالوا : يا رسولَ اللهِ ! ولا الجهادُ في سبيلِ اللهِ ؟ قال : \"ولا الجهادُ في سبيلِ اللهِ ، إلَّا رجلٌ خرج بنفسِه ومالِه في سبيلِ اللهِ ، ثمَّ لم يرجِعْ من ذلك بشيءٍ\".",
          bookInfo:
              "الراوي : عبدالله بن عباس | المحدث : أبو نعيم | المصدر : حلية الأولياء\nالصفحة أو الرقم : 4/330 | خلاصة حكم المحدث : صحيح متفق عليه [أي:بين العلماء] من حديث الأعمش",
        ),
      ],
    ),
    IslamicEvent(
      id: 12,
      type: IslamicEventType.eidAlAdha,
      titleArabic: "عيد الأضحى المبارك",
      titleEnglish: "Eid Al-Adha",
      month: 12,
      days: [10, 11, 12, 13],
      isReminder: false,
      hadiths: [
        HadithInfo(
          hadith:
              "كنتُ مع أبي أمامةَ الباهليِّ وغيرِه من أصحابِ النَّبيِّ صلَّى اللهُ عليه وسلَّم ، فكانوا إذا رجعوا من العيدِ يقولُ بعضُهم لبعضٍ : \"تقبَّل اللهُ منَّا ومنك\"",
          bookInfo:
              "الراوي : محمد بن زياد | المحدث : الإمام أحمد | المصدر : المغني لابن قدامة\nالصفحة أو الرقم : 3/294 | خلاصة حكم المحدث : إسناده جيد",
        ),
      ],
    ),
  ];

  /// الحصول على جميع المناسبات
  static List<IslamicEvent> get allEvents => _events;

  /// الحصول على المناسبات حسب النوع
  static List<IslamicEvent> getEventsByType(IslamicEventType type) {
    return _events.where((event) => event.type == type).toList();
  }

  /// الحصول على المناسبات في شهر معين
  static List<IslamicEvent> getEventsInMonth(int month) {
    return _events.where((event) => event.month == month).toList();
  }

  /// الحصول على المناسبات اليوم
  static List<IslamicEvent> getTodaysEvents() {
    return _events.where((event) => event.isToday()).toList();
  }

  /// الحصول على المناسبات في الشهر الحالي
  static List<IslamicEvent> getEventsThisMonth() {
    return _events.where((event) => event.isThisMonth()).toList();
  }

  /// الحصول على التذكيرات فقط
  static List<IslamicEvent> getReminders() {
    return _events.where((event) => event.isReminder).toList();
  }

  /// الحصول على أقرب مناسبة قادمة
  static IslamicEvent? getNextEvent() {
    IslamicEvent? nextEvent;
    int minDays = 999999;

    for (var event in _events) {
      int daysUntil = event.daysUntilEvent();
      if (daysUntil > 0 && daysUntil < minDays) {
        minDays = daysUntil;
        nextEvent = event;
      }
    }

    return nextEvent;
  }

  /// البحث عن مناسبة بنوعها
  static List<IslamicEvent> findEventsByType(IslamicEventType type) {
    return _events.where((event) => event.type == type).toList();
  }

  /// الحصول على جميع المناسبات المهمة (غير التذكيرات)
  static List<IslamicEvent> getMainEvents() {
    return _events.where((event) => !event.isReminder).toList();
  }

  /// البحث في النصوص العربية والإنجليزية
  static List<IslamicEvent> searchEvents(String query) {
    final lowerQuery = query.toLowerCase();
    return _events
        .where((event) =>
            event.titleArabic.toLowerCase().contains(lowerQuery) ||
            event.titleEnglish.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// الحصول على الأحاديث المرتبطة بنوع المناسبة
  static List<HadithInfo> getHadithsForEventType(IslamicEventType type) {
    final events = findEventsByType(type);
    final List<HadithInfo> allHadiths = [];
    for (var event in events) {
      allHadiths.addAll(event.hadiths);
    }
    return allHadiths;
  }

  /// الحصول على إحصائيات المناسبات
  static Map<String, int> getEventsStatistics() {
    return {
      'totalEvents': _events.length,
      'mainEvents': getMainEvents().length,
      'reminders': getReminders().length,
      'eventsWithHadiths': _events.where((e) => e.hadiths.isNotEmpty).length,
    };
  }

  /// الحصول على المناسبات المقبلة في الأشهر القادمة
  static List<IslamicEvent> getUpcomingEvents({int monthsAhead = 3}) {
    final now = DateTime.now();
    final currentHijri = HijriDate.fromDate(now);
    final List<IslamicEvent> upcomingEvents = [];

    for (int i = 0; i <= monthsAhead; i++) {
      int targetMonth = ((currentHijri.hMonth - 1 + i) % 12) + 1;

      final monthEvents = getEventsInMonth(targetMonth);
      for (var event in monthEvents) {
        if (event.daysUntilEvent() > 0) {
          upcomingEvents.add(event);
        }
      }
    }

    // ترتيب حسب الأيام المتبقية
    upcomingEvents
        .sort((a, b) => a.daysUntilEvent().compareTo(b.daysUntilEvent()));
    return upcomingEvents;
  }

  /// حساب الأيام المتبقية لنهاية الشهر الحالي
  static int daysUntilEndOfCurrentMonth() {
    final now = DateTime.now();
    final currentHijri = HijriDate.fromDate(now);
    final daysInMonth =
        currentHijri.getDaysInMonth(currentHijri.hYear, currentHijri.hMonth);

    return daysInMonth - currentHijri.hDay;
  }

  /// حساب الأيام المتبقية لبداية الشهر القادم
  static int daysUntilNextMonth() {
    return daysUntilEndOfCurrentMonth() + 1;
  }

  /// حساب الأيام المتبقية لنهاية السنة الهجرية الحالية
  static int daysUntilEndOfYear() {
    final now = DateTime.now();
    final currentHijri = HijriDate.fromDate(now);
    int totalDays = 0;

    // أيام متبقية في الشهر الحالي
    totalDays += daysUntilEndOfCurrentMonth();

    // أيام الأشهر المتبقية في السنة
    for (int month = currentHijri.hMonth + 1; month <= 12; month++) {
      totalDays += currentHijri.getDaysInMonth(currentHijri.hYear, month);
    }

    return totalDays;
  }
}

// مثال على الاستخدام
/*
void main() {
  // الحصول على المناسبات اليوم
  var todaysEvents = IslamicEventsManager.getTodaysEvents();
  for (var event in todaysEvents) {
    print('اليوم: ${event.getTitle('ar')}');
    print('Today: ${event.getTitle('en')}');
  }

  // الحصول على أقرب مناسبة قادمة
  var nextEvent = IslamicEventsManager.getNextEvent();
  if (nextEvent != null) {
    print('المناسبة القادمة: ${nextEvent.getTitle('ar')}');
    print('خلال ${nextEvent.daysUntilEvent()} يوم');
  }

  // الحصول على مناسبات رمضان
  var ramadanEvents = IslamicEventsManager.getEventsInMonth(9);
  for (var event in ramadanEvents) {
    print('رمضان: ${event.getTitle('ar')}');
  }

  // الحصول على التذكيرات فقط
  var reminders = IslamicEventsManager.getReminders();
  for (var reminder in reminders) {
    print('تذكير: ${reminder.getTitle('ar')}');
  }

  // حساب الأيام المتبقية لنهاية الشهر
  int daysLeft = IslamicEventsManager.daysUntilEndOfCurrentMonth();
  print('أيام متبقية في الشهر: $daysLeft');
  
  // حساب الأيام المتبقية لنهاية السنة
  int daysLeftInYear = IslamicEventsManager.daysUntilEndOfYear();
  print('أيام متبقية في السنة: $daysLeftInYear');
}
*/
