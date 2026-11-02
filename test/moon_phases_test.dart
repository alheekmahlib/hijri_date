import 'package:flutter_test/flutter_test.dart';
import 'package:hijri_date/moon_phases.dart';
import 'package:hijri_date/hijri_date.dart';

void main() {
  // NASA SKYCAL: 2026-11-01 20:28 UTC, last quarter.
  test('November 2026 last quarter and the following hours', () {
    final quarter =
        MoonPhaseCalculator.getMoonPhase(DateTime.utc(2026, 11, 1, 20, 28));
    expect(quarter.phase, MoonPhase.lastQuarter);
    expect(quarter.illumination, closeTo(.5, .015));

    // 4:26 pm in Los Angeles on November 1, after the DST transition.
    final screenshotTime =
        MoonPhaseCalculator.getMoonPhase(DateTime.utc(2026, 11, 2, 0, 26));
    expect(screenshotTime.phase, MoonPhase.lastQuarter);
    expect(screenshotTime.illumination, inExclusiveRange(.45, .50));
    expect(screenshotTime.age, inInclusiveRange(22, 23));
  });

  test('principal phases agree with November 2026 NASA event times', () {
    final events = <DateTime, MoonPhase>{
      DateTime.utc(2026, 11, 9, 7, 2): MoonPhase.newMoon,
      DateTime.utc(2026, 11, 17, 11, 48): MoonPhase.firstQuarter,
      DateTime.utc(2026, 11, 24, 14, 53): MoonPhase.fullMoon,
      DateTime.utc(2026, 12, 1, 6, 8): MoonPhase.lastQuarter,
    };
    for (final event in events.entries) {
      final info = MoonPhaseCalculator.getMoonPhase(event.key);
      expect(info.phase, event.value);
      final expected = switch (event.value) {
        MoonPhase.newMoon => 0.0,
        MoonPhase.fullMoon => 1.0,
        _ => .5,
      };
      expect(info.illumination, closeTo(expected, .015));
    }
  });

  test('phase calculations represent the same instant in local and UTC time',
      () {
    final utc = DateTime.utc(2026, 11, 2, 0, 26);
    final a = MoonPhaseCalculator.getMoonPhase(utc);
    final b = MoonPhaseCalculator.getMoonPhase(utc.toLocal());
    expect(a.phase, b.phase);
    expect(a.illumination, closeTo(b.illumination, 1e-12));
    expect(a.age, closeTo(b.age, 1e-10));
  });

  test('HijriDate preserves the original instant when calculating the phase',
      () {
    final instant = DateTime.utc(2026, 11, 2, 0, 26);
    final date = HijriDate.fromDate(instant);
    final info = date.getMoonPhase();
    final expected = MoonPhaseCalculator.getMoonPhase(instant);
    expect(info.phase, expected.phase);
    expect(MoonPhaseCalculator.getMoonPhaseForHijri(date).illumination,
        closeTo(expected.illumination, 1e-12));
    expect(info.illumination, closeTo(expected.illumination, 1e-12));
  });

  test('upcoming new and full moons follow NASA SKYCAL within two hours', () {
    final info = MoonPhaseCalculator.getMoonPhase(DateTime.utc(2026, 11, 2));
    final newMoon = DateTime.utc(2026, 11, 9, 7, 2);
    final fullMoon = DateTime.utc(2026, 11, 24, 14, 53);
    expect(info.nextNewMoon.difference(newMoon).inMinutes.abs(), lessThan(120));
    expect(
        info.nextFullMoon.difference(fullMoon).inMinutes.abs(), lessThan(120));
    expect(info.nextNewMoon.isBefore(info.nextFullMoon), isTrue);
  });
}
