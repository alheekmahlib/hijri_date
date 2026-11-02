import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hijri_date/moon_phase_widget.dart';
import 'package:hijri_date/moon_phases.dart';

MoonPhaseInfo moon(MoonPhase phase, double illumination, double age) {
  return MoonPhaseInfo(
    phase: phase,
    illumination: illumination,
    age: age,
    nextFullMoon: DateTime(2026, 1, age < 14.8 ? 2 : 3),
    nextNewMoon: DateTime(2026, 1, age < 14.8 ? 3 : 2),
    arabicName: 'هلال متزايد',
    englishName: 'Waxing Crescent',
  );
}

Future<CustomPainter> painterFor(WidgetTester tester, MoonPhaseInfo info,
    {double scale = 1}) async {
  await tester.pumpWidget(Directionality(
    textDirection: TextDirection.ltr,
    child: MoonPhaseWidget(
      moonInfo: info,
      size: 130,
      overlayOpacity: 1,
      moonScale: scale,
    ),
  ));
  return tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((widget) => widget.painter)
      .whereType<CustomPainter>()
      .firstWhere((painter) =>
          painter.runtimeType.toString() == '_MoonPhaseOverlayPainter');
}

Future<int> alphaAt(
    WidgetTester tester, CustomPainter painter, int x, int y) async {
  return (await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    painter.paint(Canvas(recorder), const Size(100, 100));
    final picture = recorder.endRecording();
    final image = await picture.toImage(100, 100);
    final pixels = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final alpha = pixels!.getUint8((y * 100 + x) * 4 + 3);
    image.dispose();
    picture.dispose();
    return alpha;
  }))!;
}

void main() {
  testWidgets('phase name can be shown, localized, styled and hidden',
      (tester) async {
    const style = TextStyle(fontSize: 21);
    Widget buildMoon({bool show = false, String? language}) {
      return Localizations(
        locale: const Locale('ar'),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MoonPhaseWidget(
            moonInfo: moon(MoonPhase.waxingCrescent, .25, 5),
            showPhaseName: show,
            phaseNameLanguage: language,
            phaseNameStyle: style,
          ),
        ),
      );
    }

    await tester.pumpWidget(buildMoon());
    expect(find.text('هلال متزايد'), findsNothing);
    await tester.pumpWidget(buildMoon(show: true));
    expect(find.text('هلال متزايد'), findsOneWidget);
    expect(tester.widget<Text>(find.text('هلال متزايد')).style, style);
    await tester.pumpWidget(buildMoon(show: true, language: 'en'));
    expect(find.text('Waxing Crescent'), findsOneWidget);
    expect(find.text('هلال متزايد'), findsNothing);
    await tester.pumpWidget(buildMoon());
    expect(find.text('Waxing Crescent'), findsNothing);
  });

  testWidgets('moon asset supports raster images and SVG', (tester) async {
    Widget buildMoon(String path) => Directionality(
          textDirection: TextDirection.ltr,
          child: MoonPhaseWidget(
            moonInfo: moon(MoonPhase.firstQuarter, .5, 7),
            moonAssetPath: path,
          ),
        );

    await tester.pumpWidget(buildMoon('assets/moon.png'));
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(SvgPicture), findsNothing);
    await tester.pumpWidget(buildMoon('assets/moon.svg'));
    expect(find.byType(Image), findsNothing);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('shadow is softly feathered but stays inside the disk',
      (tester) async {
    final quarter = await painterFor(
        tester, moon(MoonPhase.firstQuarter, .5, 7),
        scale: .8);
    expect(await alphaAt(tester, quarter, 49, 50), inExclusiveRange(0, 255));
    expect(await alphaAt(tester, quarter, 5, 50), 0);
    expect(await alphaAt(tester, quarter, 30, 50), 255);
  });

  testWidgets('terminator follows crescent, quarter, and gibbous geometry',
      (tester) async {
    final crescent =
        await painterFor(tester, moon(MoonPhase.waxingCrescent, .25, 5));
    expect(await alphaAt(tester, crescent, 70, 50), 255);
    expect(await alphaAt(tester, crescent, 80, 50), 0);
    expect(await alphaAt(tester, crescent, 65, 25), 255);
    expect(await alphaAt(tester, crescent, 75, 25), 0);

    final quarter =
        await painterFor(tester, moon(MoonPhase.firstQuarter, .5, 7));
    expect(await alphaAt(tester, quarter, 40, 50), 255);
    expect(await alphaAt(tester, quarter, 60, 50), 0);
    expect(await alphaAt(tester, quarter, 40, 25), 255);
    expect(await alphaAt(tester, quarter, 60, 25), 0);

    final gibbous =
        await painterFor(tester, moon(MoonPhase.waningGibbous, .75, 19));
    expect(await alphaAt(tester, gibbous, 20, 50), 0);
    expect(await alphaAt(tester, gibbous, 80, 50), 255);
  });

  testWidgets('new and full moon intervals use age to choose direction',
      (tester) async {
    final waxing = await painterFor(tester, moon(MoonPhase.newMoon, .1, .5));
    final waning = await painterFor(tester, moon(MoonPhase.newMoon, .1, 29));
    expect(await alphaAt(tester, waxing, 95, 50), 0);
    expect(await alphaAt(tester, waning, 95, 50), 255);
    expect(waning.shouldRepaint(waxing), isTrue);

    final smaller =
        await painterFor(tester, moon(MoonPhase.newMoon, .1, 29), scale: .8);
    expect(smaller.shouldRepaint(waning), isTrue);
  });
}
