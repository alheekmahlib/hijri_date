import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hijri_date/hijri.dart';

void main() {
  testWidgets('shows Gregorian day under Hijri day', (tester) async {
    final hijriMin = HijriDate.fromHijri(1440, 1, 1);
    final hijriMax = HijriDate.fromHijri(1460, 12, 30);
    final hijriInitial = HijriDate.fromDate(DateTime(2024, 3, 10));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 120,
              child: HorizontalWeekCalendar(
                minDate: DateTime(2020, 1, 1),
                maxDate: DateTime(2030, 12, 31),
                initialDate: DateTime(2024, 3, 10),
                useHijriDates: true,
                hijriMinDate: hijriMin,
                hijriMaxDate: hijriMax,
                hijriInitialDate: hijriInitial,
                showGregorianUnderHijri: true,
                gregorianDayFormat: 'd',
                translateNumbers: false,
                languageCode: 'en',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final gregorianDayFinder = find.byWidgetPredicate((widget) {
      if (widget is! Text) {
        return false;
      }
      return widget.data == '10' && widget.style?.fontWeight == FontWeight.w600;
    });

    expect(gregorianDayFinder, findsWidgets);
  });
}
