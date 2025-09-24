import 'convert_number_extension.dart';

/// A utility class for converting digits between different numeral systems
/// فئة مساعدة لتحويل الأرقام بين أنظمة الترقيم المختلفة
class DigitsConverter {
  // Eastern Arabic numerals (Arabic-Indic digits)
  // الأرقام العربية الشرقية (الأرقام العربية الهندية)
  static const List<String> easternArabicNumerals = [
    '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
  ];

  // Bengali numerals
  // الأرقام البنغالية
  static const List<String> bengaliNumerals = [
    '০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'
  ];

  // Urdu numerals (Extended Arabic-Indic digits)
  // الأرقام الأردية (الأرقام العربية الهندية الموسعة)
  static const List<String> urduNumerals = [
    '۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'
  ];

  // Western numerals (used by Indonesian, Malay, Filipino, Turkish, English)
  // الأرقام الغربية (تستخدم في الإندونيسية، الماليزية، الفلبينية، التركية، الإنجليزية)
  static const List<String> westernNumerals = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  ];

  /// Legacy method for Eastern Arabic conversion (backward compatibility)
  /// طريقة قديمة لتحويل العربية الشرقية (للتوافق مع الإصدارات السابقة)
  @Deprecated('Use convertNumberToLocale instead')
  static String convertWesternNumberToEastern(int? easternNumber) {
    return convertNumberToLocale(easternNumber, 'ar');
  }

  /// Converts a number to the specified locale's numeral system
  /// يحول رقماً إلى نظام الترقيم الخاص باللغة المحددة
  /// 
  /// Supported locales:
  /// - 'ar': Arabic (٠١٢٣٤٥٦٧٨٩)
  /// - 'bn': Bengali (০১২৩৪৫৬৭৮৯)
  /// - 'ur': Urdu (۰۱۲۳۴۵۶۷۸۹)
  /// - 'en', 'id', 'ms', 'fil', 'tr': Western digits (0123456789)
  static String convertNumberToLocale(int? number, String locale) {
    if (number == null) return '';
    
    String numberString = number.toString();
    List<String>? numerals = _getNumeralsForLocale(locale);
    
    if (numerals == null) return numberString;
    
    StringBuffer result = StringBuffer();
    for (int i = 0; i < numberString.length; i++) {
      String char = numberString[i];
      if (char == '-') {
        result.write('-'); // Keep negative sign
      } else {
        int digit = int.tryParse(char) ?? 0;
        result.write(numerals[digit]);
      }
    }
    return result.toString();
  }

  /// Converts a string containing digits to the specified locale
  /// يحول نصاً يحتوي على أرقام إلى اللغة المحددة
  static String convertStringToLocale(String text, String locale) {
    return text.convertNumbers(locale);
  }

  /// Gets the numeral list for a specific locale
  /// يحصل على قائمة الأرقام للغة محددة
  static List<String>? _getNumeralsForLocale(String locale) {
    switch (locale) {
      case 'ar':
        return easternArabicNumerals;
      case 'bn':
        return bengaliNumerals;
      case 'ur':
        return urduNumerals;
      case 'en':
      case 'id':
      case 'ms':
      case 'fil':
      case 'tr':
        return westernNumerals;
      default:
        return null;
    }
  }

  /// Checks if a locale is supported for digit conversion
  /// يتحقق من دعم لغة معينة لتحويل الأرقام
  static bool isLocaleSupported(String locale) {
    return _getNumeralsForLocale(locale) != null;
  }

  /// Gets all supported locales for digit conversion
  /// يحصل على جميع اللغات المدعومة لتحويل الأرقام
  static List<String> getSupportedLocales() {
    return ['ar', 'bn', 'ur', 'en', 'id', 'ms', 'fil', 'tr'];
  }

  /// Gets sample digits for a specific locale (0-9)
  /// يحصل على عينة من الأرقام للغة محددة (0-9)
  static String getSampleDigits(String locale) {
    List<String>? numerals = _getNumeralsForLocale(locale);
    if (numerals == null) return '0123456789';
    return numerals.join();
  }
}
