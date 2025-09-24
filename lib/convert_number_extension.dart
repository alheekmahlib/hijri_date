/// Extension for converting numbers to different localized formats
/// امتداد لتحويل الأرقام إلى تنسيقات محلية مختلفة
extension ConvertNumberExtension on String {
  /// Converts Western digits (0-9) to localized digits based on language
  /// يحول الأرقام الغربية (0-9) إلى أرقام محلية حسب اللغة
  /// 
  /// Supported languages:
  /// - Arabic (ar): ٠١٢٣٤٥٦٧٨٩
  /// - English (en): 0123456789 
  /// - Bengali (bn): ০১২৩৪৫৬৭৮৯
  /// - Urdu (ur): ۰۱۲۳۴۵۶۷۸۹
  /// - Indonesian (id): 0123456789 (uses Western)
  /// - Malay (ms): 0123456789 (uses Western)
  /// - Filipino (fil): 0123456789 (uses Western)
  /// - Turkish (tr): 0123456789 (uses Western)
  String convertNumbers(String? languageCode) {
    return languageCode != null ? _convertWithLang(languageCode) : this;
  }

  /// Helper function to convert numbers by language
  /// دالة مساعدة لتحويل الأرقام حسب اللغة
  String _convertWithLang(String languageCode) {
    // Number sets for different languages
    // مجموعات الأرقام للغات المختلفة
    Map<String, Map<String, String>> numberSets = {
      'ar': {
        // Arabic - العربية (Eastern Arabic-Indic digits)
        '0': '٠', '1': '١', '2': '٢', '3': '٣', '4': '٤',
        '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩',
      },
      'bn': {
        // Bengali - বাংলা (Bengali digits)
        '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪',
        '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯',
      },
      'ur': {
        // Urdu - اردو (Extended Arabic-Indic digits)
        '0': '۰', '1': '۱', '2': '۲', '3': '۳', '4': '۴',
        '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹',
      },
      // Languages that use Western digits
      // اللغات التي تستخدم الأرقام الغربية
      'en': _westernDigits, // English - الإنجليزية
      'id': _westernDigits, // Indonesian - الإندونيسية
      'ms': _westernDigits, // Malay - الماليزية  
      'fil': _westernDigits, // Filipino - الفلبينية
      'tr': _westernDigits, // Turkish - التركية
    };

    Map<String, String>? numSet = numberSets[languageCode];
    if (numSet == null) return this;

    String convertedStr = this;
    for (var entry in numSet.entries) {
      convertedStr = convertedStr.replaceAll(entry.key, entry.value);
    }
    return convertedStr;
  }

  /// Western digits mapping (0-9)
  /// تعيين الأرقام الغربية (0-9)
  static const Map<String, String> _westernDigits = {
    '0': '0', '1': '1', '2': '2', '3': '3', '4': '4',
    '5': '5', '6': '6', '7': '7', '8': '8', '9': '9',
  };
}
