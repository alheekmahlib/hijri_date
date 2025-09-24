import '../lib/convert_number_extension.dart';
import '../lib/digits_converter.dart';
import '../lib/hijri_calendar.dart';

void main() {
  print('🌍 مثال شامل لدعم اللغات المتعددة في مكتبة التاريخ الهجري');
  print('=' * 60);

  // Current Hijri date
  var today = HijriCalendar.now();

  print('📅 التاريخ الهجري اليوم بلغات مختلفة:');
  print('-' * 40);

  // Test all supported languages
  Map<String, String> languages = {
    'ar': 'العربية',
    'en': 'English',
    'tr': 'Türkçe',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'fil': 'Filipino',
    'bn': 'বাংলা',
    'ur': 'اردو',
  };

  for (var entry in languages.entries) {
    String locale = entry.key;
    String languageName = entry.value;

    HijriCalendar.setLocal(locale);
    var date = HijriCalendar.fromHijri(today.hYear, today.hMonth, today.hDay);

    print('🏳️  $languageName ($locale):');
    print('   📆 ${date.fullDate()}');
    print('   📅 ${date.toFormat('DDDD, MMMM dd, yyyy')}');
    print('   🔢 ${date.toFormat('dd/mm/yyyy')}');
    print('   📊 الشهر: ${date.getLongMonthName()}');
    print('   📋 يوم: ${date.getDayName()}');
    print('');
  }

  print('🔢 أمثلة تحويل الأرقام:');
  print('-' * 30);

  int sampleNumber = 12345;
  print('الرقم الأصلي: $sampleNumber');
  print('');

  for (var entry in languages.entries) {
    String locale = entry.key;
    String languageName = entry.value;
    String convertedNumber =
        DigitsConverter.convertNumberToLocale(sampleNumber, locale);
    String sampleDigits = DigitsConverter.getSampleDigits(locale);

    print('🏳️  $languageName ($locale):');
    print('   الرقم: $convertedNumber');
    print('   الأرقام: $sampleDigits');
    print('');
  }

  print('📊 معلومات مفيدة:');
  print('-' * 20);

  List<String> supportedLocales = DigitsConverter.getSupportedLocales();
  print('🌍 اللغات المدعومة: ${supportedLocales.join(', ')}');
  print('📈 عدد اللغات: ${supportedLocales.length}');

  print('');
  print('✅ اختبار دعم اللغات:');
  for (String locale in supportedLocales) {
    bool isSupported = DigitsConverter.isLocaleSupported(locale);
    print('   $locale: ${isSupported ? '✓' : '✗'}');
  }

  print('');
  print('🗓️  مثال: شهر رمضان بلغات مختلفة:');
  print('-' * 35);

  Map<String, String> ramadanNames = {
    'ar': 'رمضان',
    'en': 'Ramadan',
    'tr': 'RAMAZAN',
    'id': 'Ramadan',
    'ms': 'Ramadan',
    'fil': 'Ramadan',
    'bn': 'রমজান',
    'ur': 'رمضان',
  };

  for (var entry in ramadanNames.entries) {
    String locale = entry.key;
    String expectedName = entry.value;

    HijriCalendar.setLocal(locale);
    var ramadanDate = HijriCalendar.fromHijri(1445, 9, 1);
    String actualName = ramadanDate.getLongMonthName();

    print(
        '🏳️  ${languages[locale]} ($locale): $actualName ${actualName == expectedName ? '✓' : '✗'}');
  }

  print('');
  print('🌙 مثال عملي: تاريخ مهم (منتصف رمضان 1445 هـ):');
  print('-' * 45);

  for (var entry in languages.entries) {
    String locale = entry.key;
    String languageName = entry.value;

    HijriCalendar.setLocal(locale);
    var importantDate = HijriCalendar.fromHijri(1445, 9, 15);

    print('🏳️  $languageName: ${importantDate.toFormat('dd MMMM yyyy')}');
  }

  print('');
  print('📱 أمثلة استخدام Extension:');
  print('-' * 30);

  String mixedText = 'Today is 15/9/1445 - اليوم هو 15/9/1445';
  print('النص الأصلي: $mixedText');
  print('');

  List<String> numericLocales = ['ar', 'bn', 'ur'];
  for (String locale in numericLocales) {
    String converted = mixedText.convertNumbers(locale);
    print('🏳️  ${languages[locale]}: $converted');
  }

  print('');
  print('⚡ اختبار الأداء:');
  print('-' * 15);

  Stopwatch stopwatch = Stopwatch()..start();

  // Convert 1000 numbers to test performance
  for (int i = 0; i < 1000; i++) {
    DigitsConverter.convertNumberToLocale(i, 'ar');
  }

  stopwatch.stop();
  print('⏱️  تحويل 1000 رقم إلى العربية: ${stopwatch.elapsedMilliseconds}ms');

  print('');
  print('🎯 نصائح للاستخدام:');
  print('-' * 17);
  print('1. استخدم HijriCalendar.setLocal() لتغيير اللغة');
  print('2. استخدم DigitsConverter.convertNumberToLocale() لتحويل الأرقام');
  print('3. استخدم String.convertNumbers() كـ extension');
  print('4. تحقق من دعم اللغة باستخدام isLocaleSupported()');
  print('');

  // Reset to English
  HijriCalendar.setLocal('en');

  print('✨ تم الانتهاء من المثال - Multi-language example completed!');
}
