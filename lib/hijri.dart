/// Hijri Date Library - مكتبة التاريخ الهجري
/// A comprehensive Dart library for Islamic (Hijri) calendar operations
///
/// This library provides:
/// - Hijri to Gregorian date conversion and vice versa
/// - Islamic calendar localization for multiple languages
/// - Moon phases calculation
/// - Islamic events and religious occasions
/// - Date formatting and manipulation
/// - Age calculations and utilities
///
/// Usage:
/// ```dart
/// import 'package:hijri_date/hijri.dart';
///
/// // Create Hijri date
/// var hijriDate = HijriDate.now();
/// print(hijriDate.fullDate());
///
/// // Get moon phase
/// var moonPhase = hijriDate.getMoonPhase();
/// print(moonPhase.englishName);
///
/// // Get Islamic events
/// var events = IslamicEventsManager.getTodaysEvents();
///
/// // Convert digits to different locales
/// var arabicNumber = DigitsConverter.convertNumberToLocale(123, 'ar');
/// print(arabicNumber); // ١٢٣
///
/// // Calculate age
/// var birthDate = HijriDate.fromHijri(1400, 1, 1);
/// var age = AgeCalculator.calculateDetailedAge(birthDate);
/// print('العمر: ${age['years']} سنة و ${age['months']} شهر');
/// ```

library hijri;

export 'convert_number_extension.dart';
export 'digits_converter.dart';
// Localization and formatting
export 'hijri_array.dart';
// Core date functionality
export 'hijri_date.dart';
// Utilities and helper functions
export 'hijri_utils.dart';
// Moon phases and astronomical calculations
export 'moon_phases.dart';
// Islamic events and religious occasions
export 'religious_event.dart';
