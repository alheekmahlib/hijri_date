import '../lib/hijri_calendar.dart';
import '../lib/moon_phases.dart';

void main() {
  print('🌙 مثال شامل لاستخدام ميزة أطوار القمر\n');
  print('=' * 50);

  // إعداد اللغة العربية
  HijriCalendar.setLocal('ar');

  // الحصول على التاريخ الهجري الحالي
  var today = HijriCalendar.now();
  print('📅 اليوم: ${today.fullDate()}');

  // حساب طور القمر للتاريخ الحالي
  var moonInfo = today.getMoonPhase();
  print('\n🌙 معلومات القمر اليوم:');
  print(today.moonInfo());
  print(
      '   نسبة الإضاءة: ${(moonInfo.illumination * 100).toStringAsFixed(1)}%');
  print('   عمر القمر: ${moonInfo.age.toStringAsFixed(1)} يوم');

  // التحقق من الأطوار الخاصة
  print('\n🔍 التحقق من الأطوار:');
  print('   هل هو بدر؟ ${today.isFullMoon() ? "نعم 🌕" : "لا"}');
  print('   هل هو محاق؟ ${today.isNewMoon() ? "نعم 🌑" : "لا"}');
  print('   هل يمكن رؤية الهلال؟ ${today.isHilalVisible() ? "نعم 🌙" : "لا"}');

  // حساب التواريخ القادمة
  print('\n📊 التواريخ القادمة:');
  print('   البدر التالي بعد: ${today.daysUntilNextFullMoon()} يوم');
  print('   المحاق التالي بعد: ${today.daysUntilNextNewMoon()} يوم');

  print('\n' + '=' * 50);

  // الحصول على جميع تواريخ البدر في السنة الحالية
  print('🌕 تواريخ البدر في السنة ${today.hYear}:');
  var fullMoons = today.getFullMoonDatesThisYear();
  for (int i = 0; i < fullMoons.length; i++) {
    var date = fullMoons[i];
    print('   ${i + 1}. ${date.fullDate()}');
  }

  print('\n' + '=' * 50);

  // الحصول على جميع تواريخ المحاق في السنة الحالية
  print('🌑 تواريخ المحاق في السنة ${today.hYear}:');
  var newMoons = today.getNewMoonDatesThisYear();
  for (int i = 0; i < newMoons.length; i++) {
    var date = newMoons[i];
    print('   ${i + 1}. ${date.fullDate()}');
  }

  print('\n' + '=' * 50);

  // احصائيات أطوار القمر للشهر الحالي
  print('📈 احصائيات أطوار القمر للشهر ${today.getLongMonthName()}:');
  var stats = today.getMoonPhaseStatisticsThisMonth();

  Map<MoonPhase, String> arabicPhaseNames = {
    MoonPhase.newMoon: 'محاق',
    MoonPhase.waxingCrescent: 'هلال متزايد',
    MoonPhase.firstQuarter: 'تربيع أول',
    MoonPhase.waxingGibbous: 'أحدب متزايد',
    MoonPhase.fullMoon: 'بدر',
    MoonPhase.waningGibbous: 'أحدب متناقص',
    MoonPhase.lastQuarter: 'تربيع ثاني',
    MoonPhase.waningCrescent: 'هلال متناقص',
  };

  stats.forEach((phase, count) {
    if (count > 0) {
      print('   ${arabicPhaseNames[phase]}: $count أيام');
    }
  });

  print('\n' + '=' * 50);

  // أمثلة لشهر رمضان 1445
  print('🌙 أمثلة خاصة - شهر رمضان 1445:');

  // أول رمضان
  var ramadanStart = HijriCalendar.fromHijri(1445, 9, 1);
  print('\n📅 أول رمضان: ${ramadanStart.fullDate()}');
  print('   ${ramadanStart.moonInfo()}');
  print('   يمكن رؤية الهلال: ${ramadanStart.isHilalVisible() ? "نعم" : "لا"}');

  // وسط رمضان
  var ramadanMiddle = HijriCalendar.fromHijri(1445, 9, 15);
  print('\n📅 وسط رمضان: ${ramadanMiddle.fullDate()}');
  print('   ${ramadanMiddle.moonInfo()}');
  print('   هل هو بدر: ${ramadanMiddle.isFullMoon() ? "نعم 🌕" : "لا"}');

  // آخر رمضان
  var ramadanEnd = HijriCalendar.fromHijri(1445, 9, 30);
  print('\n📅 آخر رمضان: ${ramadanEnd.fullDate()}');
  print('   ${ramadanEnd.moonInfo()}');

  print('\n' + '=' * 50);

  // التبديل إلى الإنجليزية لإظهار الفرق
  HijriCalendar.setLocal('en');
  print('🌍 Same information in English:');

  var todayEn = HijriCalendar.now();
  print('📅 Today: ${todayEn.fullDate()}');
  print('🌙 Moon info: ${todayEn.moonInfo()}');

  print('\n🌕 Full moons this year:');
  var fullMoonsEn = HijriCalendar.getFullMoonDatesInYear(todayEn.hYear);
  for (int i = 0; i < 3 && i < fullMoonsEn.length; i++) {
    var date = fullMoonsEn[i];
    print('   ${i + 1}. ${date.fullDate()}');
  }
  if (fullMoonsEn.length > 3) {
    print('   ... and ${fullMoonsEn.length - 3} more');
  }

  print('\n' + '=' * 50);

  // أمثلة على الدوال الثابتة
  print('🔧 Static methods examples:');

  // حساب طور القمر لتاريخ محدد
  var specificMoonInfo = HijriCalendar.getMoonPhaseForDate(1445, 9, 14);
  print(
      'Moon phase for 14 Ramadan 1445: ${MoonPhaseCalculator.getPhaseName(specificMoonInfo.phase, "en")}');

  // التحقق من رؤية الهلال لتاريخ محدد
  var hilalVisible = HijriCalendar.isHilalVisibleForDate(1445, 10, 1);
  print('Hilal visible on 1 Shawwal 1445: ${hilalVisible ? "Yes" : "No"}');

  // احصائيات شهر محدد
  var ramadanStats = HijriCalendar.getMoonPhaseStatisticsForMonth(1445, 9);
  print('Ramadan 1445 moon phase days:');
  ramadanStats.forEach((phase, count) {
    if (count > 0) {
      print('   ${MoonPhaseCalculator.getPhaseName(phase, "en")}: $count days');
    }
  });

  print('\n' + '=' * 50);
  print('✨ تم الانتهاء من المثال - Moon phases example completed!');

  // إعادة تعيين اللغة للعربية
  HijriCalendar.setLocal('ar');
}
